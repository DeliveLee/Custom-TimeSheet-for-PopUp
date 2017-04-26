//
//  ViewController.swift
//  TimeSheetPicker
//
//  Created by DeliveLee on 2017/4/26.
//  Copyright © 2017年 DeliveLee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ScheduleViewDelegate {

    @IBOutlet weak var lblTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func btnDisplayClicked(_ sender: UIButton) {
                let nib:Array = Bundle.main.loadNibNamed("ScheduleView", owner: self, options: nil)!
                let scheduleView = nib[0] as? ScheduleView
                scheduleView?.setData(frame: self.view.frame, maxSelectedNum: 3, timeMinsGap: 30, timeHourGap: 1, startDate: Date(), endDate: Date().dateByAddingDays(3), everyDayStartTime: 8, everyDayEndTime: 15)
                scheduleView?.delegate = self
                self.view.addSubview(scheduleView!)

    }
    
    
    func scheduleSelectDone(_ timeArr: [[String:Any]]){
        var lblStr :String = ""
        for item in timeArr{
            let fromtimeDate = item["fromTime"] as! Date
            let totimeDate = item["toTime"] as! Date
            lblStr += "from: \(fromtimeDate.toString(.custom("EEE, MMM dd, HH:mm"))) \n to: \(totimeDate.toString(.custom("EEE, MMM dd, HH:mm"))) \n\n"
        }
        self.lblTime.text = lblStr
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

