//http://www.mongodb.org/display/DOCS/Mongo+Wire+Protocol#MongoWireProtocol-OPQUERY
//http://java.dzone.com/articles/event-streaming-mongodb


load("js/validate_document.js");
/**
 * Tailable means cursor is not closed when the last data is retrieved.
 * Rather, the cursor marks the final object's position.
 * You can resume using the cursor later, from where it was located, if more data were received.
 * Like any "latent cursor", the cursor may become invalid at some point (CursorNotFound) - for example if the final object it references were deleted.
 */
var QUERYOPTION_TAILABLE = 2;
/**
 * Use with TailableCursor.
 * If we are at the end of the data, block for a while rather than returning no data.
 * After a timeout period, we do return as normal.
 */
var QUERYOPTION_AWAITDATA = 32;

/**
 * wait milliseconds between documents
 */
var WAIT_MILISECONDS = 100;

function threadSleep(ms) {
    ms += new Date().getTime();
    while (new Date() < ms);
}

function validate_data(lastTimeStamp) {
    print("DEBUG: validate data");

    var lastTimeStamp = lastTimeStamp;

    var projection = {};
    var sort = {$natural: 1};

    while (true) {
        var query = {
            ns: "database.collection"
        };
        if (lastTimeStamp == 0) {
            query.ts = {$gte: Timestamp(lastTimeStamp, 0)};
        } else {
            query.ts = {$gt: lastTimeStamp};
        }
        var oplogCursor = db["oplog.rs"].find(query,projection)
            .sort(sort)
            .addOption(QUERYOPTION_TAILABLE)
            .addOption(QUERYOPTION_AWAITDATA);
        while (oplogCursor.hasNext()) {
            var oplogDocument = oplogCursor.next();
            lastTimeStamp = oplogDocument.ts;
            validate_document(oplogDocument);
            threadSleep(WAIT_MILISECONDS);
        }
    }
};

validate_data(lastTimeStamp);

