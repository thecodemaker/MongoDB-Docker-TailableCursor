//http://www.mongodb.org/display/DOCS/Mongo+Wire+Protocol#MongoWireProtocol-OPQUERY
//http://java.dzone.com/articles/event-streaming-mongodb
/**
 * Tailable means cursor is not closed when the last data is retrieved.
 * Rather, the cursor marks the final object's position.
 * You can resume using the cursor later, from where it was located, if more data were received.
 * Like any "latent cursor", the cursor may become invalid at some point (CursorNotFound) - for example if the final object it references were deleted.
 */
var QUERYOPTION_TAILABLE = 2;
/**
 * When turned on, read queries will be directed to slave servers instead of the primary server.
 */
var QUERYOPTION_SLAVEOK = 4;
/**
 * Use with TailableCursor.
 * If we are at the end of the data, block for a while rather than returning no data.
 * After a timeout period, we do return as normal.
 */
var QUERYOPTION_AWAITDATA = 32;

/**
 * wait milliseconds between documents
 */
var WAIT_MILISECONDS = 100

function threadSleep(ms) {
    ms += new Date().getTime();
    while (new Date() < ms);
}

function start_mongodb_tailable_cursor(lastTimeStamp) {

    var query = {createdDtm: {"$gt": lastTimeStamp}};
    //var projection = {};
    var sort = {"$natural": 1};

    var cursor = db["oplog.rs"].find(query).sort(sort);
    cursor.addOption(QUERYOPTION_TAILABLE);
    cursor.addOption(QUERYOPTION_SLAVEOK);
    cursor.addOption(QUERYOPTION_AWAITDATA);
    while (cursor.hasNext()) {
        var object = cursor.next();
        print(object);
        threadSleep(WAIT_MILISECONDS);
    }
}

