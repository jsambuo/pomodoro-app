exports.handler = async (event, context, callback) => {
    // Log the received event
    console.log("Received event:", JSON.stringify(event, null, 2));

    // Construct the response
    const response = {
        isBase64Encoded : false,
        statusCode: 200,
        headers: {
            "Content-Type": "*/*"
        },
        body: event.body,
    };

    // Return the response
    callback(null, response);
    return response;
};
