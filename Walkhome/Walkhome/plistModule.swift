//
//  plistModule.swift
//  Walkhome
//
//  Created by Lucas Bullen on 2016-07-16.
//  Copyright © 2016 COMPSA Web Services. All rights reserved.
//

import Foundation

class accessPlist {
    /* Get row from local database
     * @param table {String}: Name of the table to look in
     * @param field {String}: Name of the field to match
     * @param value {String}: Value in field to look for
     * @return {NSArray[NSDictionary{String:String}]}: list of all rows matching query
     * Example: accessPlist().get("user", field: "local_id", value: "0")
    */
    func get(table: String, field: String, value: String)->NSArray?{
        //todo: advanced queries
        //todo: get all rows
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("localDB.plist")
        
        if let db = NSMutableDictionary(contentsOfFile: path){
            let tableArray = db.objectForKey(table)! as? NSArray
            var rowArray = [NSDictionary]()
            for row in tableArray! {
                if value == row[field] as! String {
                    rowArray.append(row as! NSDictionary)
                }
            }
            return rowArray
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("localDB", ofType: "plist"){
                if let db = NSMutableDictionary(contentsOfFile: privPath){
                    if let tableArray = db.objectForKey(table)! as? NSArray{
                        var rowArray = [NSDictionary]()
                        for row in tableArray {
                            if value == row[field] as! String {
                                rowArray.append(row as! NSDictionary)
                            }
                        }
                        return rowArray
                    }else{
                        print("No table: \(table)")
                    }
                }else{
                    print("error_read")
                }
            }else{
                print("error_read")
            }
        }
        return nil
    }
    /* Get row from local database
     * @param table {String}: Name of the table to insert into
     * @param row {NSDictionary{String:String}}: Row Dictionary to insert
     * @return {Bool}: Successful insert or not
     * Example: accessPlist().set("walk", row: ["status": "1", "time": "12345464242", "from": "Toronto", "to": "Dublin"])
     */
    func set(table: String, row: NSDictionary) -> Bool {
        //todo: confirm that row matches table schema
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("localDB.plist")
        
        if let db = NSMutableDictionary(contentsOfFile: path){
            let tableArray = db.objectForKey(table)! as? NSMutableArray
            tableArray?.addObject(row)
            db.setObject(tableArray!, forKey: table)
            return db.writeToFile(path, atomically: true)
        }else{
            if let path = NSBundle.mainBundle().pathForResource("localDB", ofType: "plist"){
                if let db = NSMutableDictionary(contentsOfFile: path){
                    let tableArray = db.objectForKey(table)! as? NSMutableArray
                    tableArray?.addObject(row)
                    db.setObject(tableArray!, forKey: table)
                    return db.writeToFile(path, atomically: true)
                }else{
                    return false
                }
            }else{
                return false
            }
        }
    }
}