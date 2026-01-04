//
//  CloudStorage.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 04.01.2026.
//

import CloudKit

class CloudStorage {
    
    static let privateDB = CKContainer.default().privateCloudDatabase
    
    static func saveFavoriteMissionsToCloud(missions: [Mission], completion: ((Result<Void, Error>) -> Void)? = nil) {
        guard let data = try? JSONEncoder().encode(missions) else { return }
        let recordID = CKRecord.ID(recordName: "favoriteMissions")
        let record = CKRecord(recordType: "UserData", recordID: recordID)
        record["missions"] = data
        
        privateDB.save(record) { record, error in
            if let error = error {
                completion?(.failure(error))
            } else {
                completion?(.success(()))
            }
        }
    }
    
    static func readFavoriteMissionsFromCloud(completion: @escaping ([Mission]) -> ()) {
        let recordID = CKRecord.ID(recordName: "favoriteMissions")
        privateDB.fetch(withRecordID: recordID) { record, error in
            if let record = record, let data = record["missions"] as? Data, let missions = try? JSONDecoder().decode([Mission].self, from: data) {
                completion(missions)
            } else {
                completion([])
            }
        }
    }
}
