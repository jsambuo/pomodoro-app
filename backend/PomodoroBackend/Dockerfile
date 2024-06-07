# ================================
# Build image
# ================================
FROM swift:5.10.0-amazonlinux2 as build

# Install build dependencies
RUN yum update -y && \
    yum install -y \
    openssl-devel \
    libcurl-devel \
    libxml2-devel \
    krb5-devel \
    libidn2-devel \
    libunistring-devel \
    libpsl-devel \
    keyutils-libs-devel \
    libselinux-devel \
    pcre2-devel \
    libnghttp2-devel \
    xz-devel

# Set up a build area
WORKDIR /build

# First just resolve dependencies.
# This creates a cached layer that can be reused
# as long as your Package.swift/Package.resolved
# files do not change.
COPY ./Package.* ./
RUN swift package resolve --skip-update \
        $([ -f ./Package.resolved ] && echo "--force-resolved-versions" || true)

# Copy entire repo into container
COPY ./Public ./Public
COPY ./Sources ./Sources
COPY ./Tests  ./Tests

# Build everything, with optimizations, with static linking, and using jemalloc
# N.B.: The static version of jemalloc is incompatible with the static Swift runtime.
RUN swift build -c release

# Switch to the staging area
WORKDIR /staging

# Copy main executable to staging area
RUN cp "$(swift build --package-path /build -c release --show-bin-path)/App" ./

# Copy static swift backtracer binary to staging area
RUN cp "/usr/libexec/swift/linux/swift-backtrace-static" ./

# Copy resources bundled by SPM to staging area
RUN find -L "$(swift build --package-path /build -c release --show-bin-path)/" -regex '.*\.resources$' -exec cp -Ra {} ./ \;

# Copy any resources from the public directory and views directory if the directories exist
# Ensure that by default, neither the directory nor any of its contents are writable.
RUN [ -d /build/Public ] && { mv /build/Public ./Public && chmod -R a-w ./Public; } || true
RUN [ -d /build/Resources ] && { mv /build/Resources ./Resources && chmod -R a-w ./Resources; } || true

# # ================================
# # Run image
# # ================================
FROM amazonlinux:2023

# Switch to the new home directory
WORKDIR /app

# Copy the executable from the build stage
COPY --from=build /staging/App /app/bootstrap

# Copy required libraries
COPY --from=build /usr/lib/swift/linux/libswiftCore.so /app/
COPY --from=build /usr/lib/swift/linux/libswift_Concurrency.so /app/
COPY --from=build /usr/lib/swift/linux/libswift_StringProcessing.so /app/
COPY --from=build /usr/lib/swift/linux/libswift_RegexParser.so /app/
COPY --from=build /usr/lib/swift/linux/libswiftGlibc.so /app/
COPY --from=build /usr/lib/swift/linux/libBlocksRuntime.so /app/
COPY --from=build /usr/lib/swift/linux/libdispatch.so /app/
COPY --from=build /usr/lib/swift/linux/libswiftDispatch.so /app/
COPY --from=build /usr/lib/swift/linux/libFoundation.so /app/
COPY --from=build /usr/lib/swift/linux/libFoundationNetworking.so /app/
COPY --from=build /usr/lib/swift/linux/libicuucswift.so.69 /app/
COPY --from=build /usr/lib/swift/linux/libicui18nswift.so.69 /app/
COPY --from=build /usr/lib/swift/linux/libicudataswift.so.69 /app/
COPY --from=build /lib64/libcrypto.so.10 /app/

# Provide configuration needed by the built-in crash reporter and some sensible default behaviors.
ENV SWIFT_BACKTRACE=enable=yes,sanitize=yes,threads=all,images=all,interactive=no,swift-backtrace=./swift-backtrace-static

# Let Docker bind to port 8080
EXPOSE 8080

# Start the Vapor service when the image is run, default to listening on 8080 in production environment
ENTRYPOINT ["/app/bootstrap"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]
