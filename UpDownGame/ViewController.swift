//
//  ViewController.swift
//  UpDownGame
//
//  Created by 권영각 on 2015. 10. 20..
//  Copyright © 2015년 LTCompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var mCurrentAnswer : Int = 0
    var mProgressIncreaseValue : Float = 0.0
    var mCount : Float = 0.0
    var available : Int = 0
    var availableCount : Int = 0
    var isUP : Bool = true
    var mTimer : Int = 10
    var mNSTimer : NSTimer? = nil
    
    @IBOutlet weak var mGameTypeSegment: UISegmentedControl!
    @IBOutlet weak var mLabelGameType: UILabel!
    @IBOutlet weak var mProgressCount: UIProgressView!
    @IBOutlet weak var mTxtField: UITextField!
    @IBOutlet weak var mTxtFieldCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initGame(0)
        
    }
    
    func initGame(index: Int){
        mGameTypeSegment.selectedSegmentIndex = index
        var range : Int = 0
        
        switch(index){
        case 0:
            range = 10
            mProgressIncreaseValue = 0.2
            available = 5
        case 1:
            range = 50
            mProgressIncreaseValue = 0.1
            available = 10
        case 2:
            range = 100
            mProgressIncreaseValue = 0.05
            available = 20
        default:
            print("default")
        }
        availableCount = 0
        mProgressCount.setProgress(0, animated: false)
        mCurrentAnswer = Int(arc4random() % UInt32(range)) + 1
        mLabelGameType.text = "0/\(available)"
        initValue()
        initTimer()
    }
    
    func initTimer(){
        mTimer = 10
        mNSTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("startTimer:"), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func valueChanged(sender: AnyObject) {
        print(sender)
        initGame(mGameTypeSegment.selectedSegmentIndex)
        
        if let timer = mNSTimer {
            setNewTimer(timer)
        }
    }
    
    @IBAction func submit(sender: AnyObject) {
        let answerText = mTxtField.text
        let answerInt = Int(answerText!)

        if let answer = answerInt {
            increaseCount()
            checkAnswer(answer)
        }
    }
    
    func checkAnswer(answer: Int){
        if mCurrentAnswer == answer {
            currect()
            return
        }
        else if mCurrentAnswer > answer {
            isUP = true
        }
        else {
            isUP = false
        }
        checkCountOver(mCount)
        incurrect()
    }
    
    func checkCountOver(count: Float){
        if mCount >= 1.0 {
            countOver()
        }
    }
    
    func increaseCount() {
        mLabelGameType.text = "\(++availableCount)/\(available)"
        mCount = mProgressCount.progress + mProgressIncreaseValue
        mProgressCount.setProgress(mCount, animated: true)
        
        checkCountOver(mCount)
    }
    
    func incurrect() {
        let dialog : UIAlertController
        if isUP {
            dialog = UIAlertController(title: "땡", message: "더 높은 값", preferredStyle: UIAlertControllerStyle.Alert)
        }
        else{
            dialog = UIAlertController(title: "땡", message: "더 낮은 값", preferredStyle: UIAlertControllerStyle.Alert)
        }
        let ccAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            self.initValue()
        }
        dialog.addAction(ccAction)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.initValue()
            self.setNewTimer(self.mNSTimer!)
        }
        dialog.addAction(okAction)
        showAlert(dialog)
    }
    
    func currect() {
        let dialog = UIAlertController(title: "딩동댕", message: "맞았음", preferredStyle: UIAlertControllerStyle.Alert)
        let ccAction = UIAlertAction(title: "끝낼래", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            print("select cancel")
        }
        dialog.addAction(ccAction)
        
        let okAction = UIAlertAction(title: "다시할래", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.initGame(self.mGameTypeSegment.selectedSegmentIndex)
            if let timer = self.mNSTimer {
                self.setNewTimer(timer)
            }
        }
        dialog.addAction(okAction)
        showAlert(dialog)
    }
    
    func showAlert(dialog: UIAlertController){
        self.presentViewController(dialog, animated: true, completion: nil)
    }
    
    
    func countOver(){
        let dialog = UIAlertController(title: "횟수 끝남", message: "답은 \(mCurrentAnswer)였음", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "초기화", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.initGame(self.mGameTypeSegment.selectedSegmentIndex)
            self.mNSTimer?.invalidate()
        }
        dialog.addAction(okAction)
        showAlert(dialog)
    }
    
    func setNewTimer(timer: NSTimer){
        timer.invalidate()
        initTimer()
    }
    
    func initValue(){
        self.mTxtField.text = ""
    }
    
    func startTimer(timer: NSTimer) {
        mTxtFieldCount.text = "\(mTimer--)"
        
        if(mTimer == -1){
            increaseCount()
            setNewTimer(timer)
        }
    }
    
}

