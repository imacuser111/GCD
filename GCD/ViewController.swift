//
//  ViewController.swift
//  GCD
//
//  Created by Cheng-Hong on 2022/9/6.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        serialQueueSync()

//        concurrentQueueAsync()

//        dispatchGroups()
//
//        dispatchGroups_Sub()
//
//        qualityOfService()
//
//        DispatchQueue.main.async {
//
//        }
//
//        // concurrent
//        DispatchQueue.global().async {
//
//        }
    }
}

// MARK: - 同步及異步

private extension ViewController {
    
    /// serial queue and sync block
    func serialQueueSync() {
        let serialQueue: DispatchQueue = DispatchQueue(label: "serialQueue")
        
        // 驗證同步執行的結果
        serialQueue.sync {
            for i in 1 ... 10 {
                print("i: \(i)")
            }
        }
        
        for j in 100 ... 109 {
            print("j: \(j)")
        }
    }
    
    /// concurrent and async
    func concurrentQueueAsync() {
        let concurrentQueue: DispatchQueue = DispatchQueue(label: "CorrentQueue", attributes: .concurrent)
        
        concurrentQueue.async {
            for i in 1 ... 100 {
                print("i: \(i)")
            }
        }
        
        concurrentQueue.async {
            for j in 1 ... 100 {
                print("j: \(j)")
            }
        }
        
        concurrentQueue.async {
            for k in 1 ... 100 {
                print("k: \(k)")
            }
        }
    }
}

// MARK: - dispatch groups 介紹及應用

private extension ViewController {
    
    /// 單純的個別執行緒
    func dispatchGroups() {
        let group: DispatchGroup = DispatchGroup()
        
        let queue1 = DispatchQueue(label: "queue1", attributes: .concurrent)
        queue1.async(group: group) {
            // 事件A
            for i in 1 ... 100 {
                print("i: \(i)")
            }
        }
        
        let queue2 = DispatchQueue(label: "queue2", attributes: .concurrent)
        queue2.async(group: group) {
            // 事件B
            for j in 101 ... 200 {
                print("j: \(j)")
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            // 已處理完事件A和事件B
            print("處理完成事件A和事件B...")
        }
    }
    
    /// 個別執行緒又有子執行緒(queue 裡又使用非同步的方式去呼叫後端的 API)
    func dispatchGroups_Sub() {
        let group: DispatchGroup = DispatchGroup()
                
        let queue1 = DispatchQueue(label: "queue1", attributes: .concurrent)
        group.enter() // 開始呼叫 API1
        queue1.async(group: group) {
          print("Call 後端 API1")
            
          // 結束呼叫 API1
          group.leave()
        }

        let queue2 = DispatchQueue(label: "queue2", attributes: .concurrent)
        group.enter() // 開始呼叫 API2
        queue2.async(group: group) {
          print("Call 後端 API2")
            
          // 結束呼叫 API2
          group.leave()
        }
                
        group.notify(queue: DispatchQueue.main) {
          // 完成所有 Call 後端 API 的動作
          print("完成所有 Call 後端 API 的動作...")
        }
    }
}

// MARK: - Quality of service(QoS)介紹及應用

extension ViewController {
    
    /// 執行緒先後順序應用  (userInteractive > userInitiated > `default` > utility > background > unspecified)
    func qualityOfService() {
        let queue1 = DispatchQueue.global(qos: .userInteractive) // 最高順位
        let queue2 = DispatchQueue.global(qos: .unspecified) // 最低順位
        
        queue1.async {
            for i in 1...10 {
                print("queue1: \(i)")
            }
        }
        
        queue2.async {
            for j in 100...110 {
                print("queue1: \(j)")
            }
        }
    }
}
