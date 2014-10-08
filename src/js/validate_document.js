/**
 *  for validation we assume that we have some conditions which should be respected
 *
 *  the document structure should be
 *
 *  document: {
 *      _id: XXX
 *      createdDtm: XXX
 *      status: {
 *          code: XXX
 *          createdDtm: XXX
 *      }
 *      statusHistory: [
 *          {
 *              code: XXX,
 *              createdDtm: XXX
 *          },
 *          {
 *              code: XXX
 *              createdDtm: XXX
 *          }
 *      ]
 *      ......
 *  }
 *
 *  and we have a transition through which the document goes
 *
 *  STATUS_A -> STATUS_B -> STATUS_C_1 -> STATUS_D
 *                       -> STATUS_C_2
 *                       -> STATUS_C_3
 */


/**
 * the structure for the oplogDocument is like:
 *
 * for insert
 * oplogDocument: {
 *    .........
 *    "op" : "i",
 *     "o" : {
 *          //document which is insert
 *     }
 * }
 *
 * for update
 * oplogDocument: {
 *    "op" : "u",
 *    "o2" : {
          "_id" : XXXX
       },
 *    "o" : {
 *          //document which is insert
 *     }
 *  }
 *
 */


//TODO - replace this with a json pattern match
function validate_document_existing_fields(document) {
    if (!document.createdDtm) {
        print("ERROR: createdDtm property missing for document with id " + document._id);
    }
    if (!document.status || !document.status.code || !document.status.createdDtm) {
        print("ERROR: status property missing for document with id " + document._id);
    }
    if (!document.statusHistory || !document.statusHistory[0].code || !document.statusHistory[0].createdDtm) {
        print("ERROR: status history property missing for document with id " + document._id);
    }
}

//TODO - replace this with a rule base verification
function validate_document_status_transaction(document) {
    //TODO
}

function validate_document(oplogDocument) {
    if (oplogDocument.op && (oplogDocument.op == "i" || oplogDocument.op == "u")) {
        if (oplogDocument.op == "i") {
            validate_document_existing_fields(oplogDocument.o);
        } else {
            var document = db.collection.find({_id: oplogDocument.o2._id})
            validate_document_status_transaction(document);
        }
    }
}