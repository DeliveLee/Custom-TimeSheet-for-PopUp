//
//  ScheduleView.swift
//  TimeSheetPicker
//
//  Created by DeliveLee on 2017/4/13.
//  Copyright © 2017年 DeliveLee. All rights reserved.
//

import UIKit

protocol ScheduleViewDelegate{
    func scheduleSelectDone(_ timeArr: [[String:Any]])
}


class ScheduleView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var ScreenView: UIView!
    @IBOutlet weak var PopView: UIView!
    
    @IBOutlet weak var TopView: TopView!
    @IBOutlet weak var topViewHeightCons: NSLayoutConstraint!

    @IBOutlet weak var MiddleView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    var maxSelectedNum: Int!
    var timeMinsGap: Int!
    var timeHourGap: Int!
    var startDate: Date!
    var endDate: Date!
    var everyDayStartTime: Int!
    var everyDayEndTime: Int!
    
    
    var timeOptionArr : [[[String:Any]]]!
    
    var delegate: ScheduleViewDelegate?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /// Use this func to set Default data
    ///
    /// - parameter frame: Set the popup size
    /// - parameter maxSelectedNum: How many opitons can select
    /// - parameter timeMinsGap: Each opiton between option's time gap
    /// - parameter timeHourGap: Option inside fromTime to toTime
    /// - parameter startDate: Can select earliest day
    /// - parameter endDate: Can select latest day
    /// - parameter everyDayStartTime: Can select earliest time everyday
    /// - parameter everyDayEndTime: Can select latest time everyday
     func setData(frame: CGRect, maxSelectedNum: Int, timeMinsGap: Int, timeHourGap: Int, startDate: Date, endDate: Date, everyDayStartTime: Int, everyDayEndTime: Int){
        self.frame = frame
        self.maxSelectedNum = maxSelectedNum
        self.timeMinsGap = timeMinsGap
        self.timeHourGap = timeHourGap
        self.startDate = startDate
        self.endDate = endDate
        self.everyDayStartTime = everyDayStartTime
        self.everyDayEndTime = everyDayEndTime
        
        self.setDefault()
        self.refreshUIWithData()
        self.collectionView.reloadData()
    }
    
    func setDefault(){
        self.timeOptionArr = Array()
        
        let xib : UINib  = UINib (nibName: "ScheduleTimeCollectionViewCell", bundle: nil)
        self.collectionView.register(xib, forCellWithReuseIdentifier: "ScheduleTimeCollectionViewCell")

        let xib2 : UINib = UINib (nibName: "ScheduleHeaderView", bundle: nil)
        self.collectionView.register(xib2, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ScheduleHeaderView")

        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let okTap = UITapGestureRecognizer(target: self, action: #selector(self.btnOKClicked))
        self.btnOK.addGestureRecognizer(okTap)
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(self.cancelClicked))
        self.btnCancel.addGestureRecognizer(cancelTap)
    }
    
    func refreshUIWithData(){
        self.timeOptionArr.removeAll()
        
        let howMuchDays = self.endDate.day() - self.startDate.day()
        let howMuchLabelsEveryDay = Int(Float(self.everyDayEndTime - self.everyDayStartTime)/(Float(self.timeMinsGap)/60.0))
        let howMuchLabelsAll = howMuchLabelsEveryDay * howMuchDays
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        for i in 0...howMuchDays-1{
            let startDate = self.startDate.dateAtStartOfDay().dateByAddingDays(i)
            
            var sectionArr : [[String:Any]] = Array()
            for k in 0...howMuchLabelsEveryDay-1{
                let labelFromTime = startDate.setTimeOfDate(self.everyDayStartTime, minute: 0, second: 0).dateByAddingMinutes(self.timeMinsGap * k)
                let labelToTime = labelFromTime.dateByAddingHours(self.timeHourGap)
                
                let labelText = "\(dateFormatter.string(from: labelFromTime)) - \(dateFormatter.string(from: labelToTime))"
                
                let itemDic = ["section": i, "fromTime": labelFromTime, "toTime": labelToTime, "labelText": labelText, "isSelected": false] as [String : Any]
                sectionArr.append(itemDic)
            }
            self.timeOptionArr.append(sectionArr)
            
        }
        
    }
    
    func btnOKClicked(){
        self.delegate?.scheduleSelectDone(self.TopView.selectedTimeArr)
        self.removeFromSuperview()
    }
    
    func cancelClicked(){
        self.removeFromSuperview()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.timeOptionArr.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.timeOptionArr[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: ScheduleTimeCollectionViewCell? = (collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleTimeCollectionViewCell", for: indexPath) as? ScheduleTimeCollectionViewCell)
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("ScheduleTimeCollectionViewCell", owner: self, options: nil)!
            cell = nib[0] as? ScheduleTimeCollectionViewCell
        }
        
        if self.timeOptionArr[indexPath.section][indexPath.row]["isSelected"] as! Bool {
            cell?.view.layer.borderColor = UIColor(rgba: "#207CF7").cgColor
            cell?.lblTime.textColor = UIColor(rgba: "#207CF7")
        }else{
            cell?.view.layer.borderColor = UIColor.lightGray.cgColor
            cell?.lblTime.textColor = UIColor.black
        }
        
        cell?.lblTime.text = self.timeOptionArr[indexPath.section][indexPath.row]["labelText"] as! String
        
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.timeOptionArr[indexPath.section][indexPath.row]["isSelected"] as! Bool {
            self.timeOptionArr[indexPath.section][indexPath.row]["isSelected"] = !(self.timeOptionArr[indexPath.section][indexPath.row]["isSelected"] as! Bool)
            self.collectionView.reloadData()
            
            self.TopView.removeATimeSelected(self.timeOptionArr[indexPath.section][indexPath.row])
            self.topViewHeightCons.constant = self.TopView.needHeight
            
        }else{
            
            var selectedNum = 0
            for i in 0...self.timeOptionArr.count-1{
                
                for k in 0...self.timeOptionArr[i].count-1{
                    guard !(self.timeOptionArr[i][k]["isSelected"] as! Bool) else {
                        selectedNum += 1
                        continue
                    }
                }
                
            }
            
            if selectedNum >= self.maxSelectedNum{
                let alert = UIAlertController(title: "Sorry", message: "You can select option up to \(String(self.maxSelectedNum))", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                let appDelegate = UIApplication.shared.delegate  as! AppDelegate
                appDelegate.window!.rootViewController!.present(alert, animated: true, completion: nil)
            }else{
                self.timeOptionArr[indexPath.section][indexPath.row]["isSelected"] = !(self.timeOptionArr[indexPath.section][indexPath.row]["isSelected"] as! Bool)
                self.collectionView.reloadData()
                self.TopView.addATimeSelected(self.timeOptionArr[indexPath.section][indexPath.row])
                self.topViewHeightCons.constant = self.TopView.needHeight

            }

            
        }
        
        
    }

    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
        
        let itemGap : Float = 5.0
        let cellWidth = (Float(ScreenSize.SCREEN_WIDTH - 60) - (itemGap * 2))/3
        return  CGSize(width: Int(cellWidth), height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 0, 5, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 50)
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ScheduleHeaderView", for: indexPath) as! ScheduleHeaderView
        
        let date = self.timeOptionArr[indexPath.section][0]["fromTime"] as! Date
        
        headView.lblDate.text = date.toString(.custom("EEE, MMM dd"))
        
        return headView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    

}


class TopView: UIView{
    
    
    var selectedTimeArr : [[String:Any]]!
    var needHeight : CGFloat!
    
    func addATimeSelected(_ timeDic: [String:Any]){
        
        self.selectedTimeArr.append(timeDic)
        self.drawLabelViewWithTimeArr()
        
    }
    func removeATimeSelected(_ timeDic: [String:Any]){
        
        for i in 0...self.selectedTimeArr.count-1 {
            if self.selectedTimeArr[i]["fromTime"] as! Date == timeDic["fromTime"] as! Date{
                self.selectedTimeArr.remove(at: i)
                self.drawLabelViewWithTimeArr()
                return
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectedTimeArr = Array()
        self.needHeight = 100
        
        self.drawLabelViewWithTimeArr()
    }

    
    func drawEmptyView(){
        self.removeSubviews()
        
        let defaultLabel = UILabel()
        defaultLabel.frame = CGRect(x: 20, y: 0, width: self.frame.size.width - 20, height: self.frame.size.height)
        defaultLabel.font = UIFont.boldSystemFont(ofSize: 20)
        defaultLabel.textColor = UIColor.white
        defaultLabel.text = "Select Your Time"
        self.addSubview(defaultLabel)

    }
    
    func drawLabelViewWithTimeArr(){

        guard self.selectedTimeArr.count>0 else {
            self.drawEmptyView()
            return
        }

        self.removeSubviews()
        
        self.selectedTimeArr.sort(by: {($0["fromTime"] as! Date) < ($1["fromTime"] as! Date)})
        
        var lastSectionNum = -1
        let startX : CGFloat = 10
        var StartY : CGFloat = 10
        for i in 0...self.selectedTimeArr.count-1 {
            if self.selectedTimeArr[i]["section"] as! Int > lastSectionNum{
               let dateLabel = UILabel()
                dateLabel.frame = CGRect(x: startX, y: StartY, width: self.frame.size.width - (startX * 2), height: CGFloat(20))
                dateLabel.text = (self.selectedTimeArr[i]["fromTime"] as! Date).toString(.custom("EEE, MMM dd"))
                dateLabel.font = UIFont.boldSystemFont(ofSize: 14)
                dateLabel.textColor = UIColor.white
                dateLabel.alpha = 0.5
                self.addSubview(dateLabel)
                
                lastSectionNum = self.selectedTimeArr[i]["section"] as! Int
                StartY += dateLabel.frame.size.height
            }
            
            let timeLabel = UILabel()
            timeLabel.frame = CGRect(x: CGFloat(startX), y: CGFloat(StartY), width: self.frame.size.width - CGFloat(startX * 2), height: CGFloat(30))
            timeLabel.text = self.selectedTimeArr[i]["labelText"] as! String
            timeLabel.font = UIFont.boldSystemFont(ofSize: 20)
            timeLabel.textColor = UIColor.white
            timeLabel.alpha = 1
            self.addSubview(timeLabel)
            StartY += timeLabel.frame.size.height
            
        }

        self.needHeight = (StartY + 10)>100 ? StartY + 10 : 100
        
        
    }

    
}
