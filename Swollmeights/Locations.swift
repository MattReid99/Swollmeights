//
//  Locations.swift
//  Swollmeights
//
//  Created by Matthew Reid on 7/29/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import Foundation

class Locations {
    
    
    static func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    
    static func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
        return cleanFile
    }

    static func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }
    
    static func printData() {
        var data = readDataFromCSV(fileName: "locations", fileType: ".txt")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
    print(csvRows[1][1]) //UXM n. 166/167.
    }
    
//    var data:[[String:String]] = []
//    var columnTitles:[String] = []
//
//func cleanRows(file:String)->String{
//    var cleanFile = file
//    cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
//    cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
//    return cleanFile
//}
//
//func getStringFieldsForRow(row:String, delimiter:String)-> [String]{
//    return row.components(separatedBy: delimiter)
//}
//
//func readDataFromFile(file:String)-> String!{
//    guard let filepath = Bundle.mainBundle.pathForResource(file, ofType: "txt")
//        else {
//            return nil
//    }
//    do {
//        let contents = try String(contentsOfFile: filepath, usedEncoding: nil)
//        return contents
//    } catch {
//        print ("File Read Error")
//        return nil
//    }
//}
//
//func convertCSV(file:String){
//    let rows = cleanRows(file: file).components(separatedBy: "\n")
//    if rows.count > 0 {
//        data = []
//        columnTitles = getStringFieldsForRow(row: rows.first!,delimiter:",")
//        for row in rows{
//            let fields = getStringFieldsForRow(row: row,delimiter: ",")
//            if fields.count != columnTitles.count {continue}
//            var dataRow = [String:String]()
//            for (index,field) in fields.enumerate(){
//                let fieldName = columnTitles[index]
//                dataRow[fieldName] = field
//                }
//            data += [dataRow]
//            }
//        } else {
//        print("No data in file")
//        }
//    }
}



