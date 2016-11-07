//
//  EncryptDecrypt.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/30.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import CryptoSwift
public class EncryptDecrypt {
    
    public class var sharedInstance: EncryptDecrypt {
        struct Static {
            static let instance: EncryptDecrypt = EncryptDecrypt()
        }
        return Static.instance
    }
    
    let Key = "rbgcHdXZ8$^ad9A>"
    let IV = "*jFfk4],GVvriiyB"
    
    func aesEncryptToHexArray(data: String) -> String? {
        do {
            let encryptData = data.dataUsingEncoding(NSUTF8StringEncoding)
            //let aes = try AES(key: Key, iv: IV, blockMode: CipherBlockMode.CBC)
            
            let aes = try AES(key: Key, iv: IV, blockMode: .CBC)
            
            let enc = try aes.encrypt((encryptData?.arrayOfBytes())!)
            
            var hexString = ""
            for byte in enc {
                let singleHex = String(format: "%02X", byte)
                hexString = hexString + singleHex
            }
            return hexString
        } catch {}
        return nil
    }
    
    func aesDecryptFromHexString(hex: String) -> String? {
        do {
            let hexString = NSString(string: hex)
            var convertedArray = [UInt8]()
            for var index = 0; index <= hexString.length - 2;  {
                let singleHex = hexString.substringWithRange(NSMakeRange(index, 2))
                let singleDec = UInt8(strtoul(singleHex, nil, 16))
                convertedArray.append(singleDec)
                index = index + 2
            }
            
            let dec = try AES(key: Key, iv: IV, blockMode: .CBC).decrypt(convertedArray)
            let decData = NSData(bytes: dec, length: Int(dec.count))
            let result = NSString(data: decData, encoding: NSUTF8StringEncoding)
            return String(result!)
        } catch {}
        return nil
    }
}