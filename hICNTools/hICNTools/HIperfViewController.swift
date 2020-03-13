//
//  HIperfViewController.swift
//  hICNTools
//
//  Created by manangel on 3/12/20.
//  Copyright © 2020 manangel. All rights reserved.
//

import UIKit
import Charts
import SwiftCharts

class HIperfViewController: BaseViewController {

    var chartDataEntryArray = [ChartDataEntry]()
    var values = [Int]()
    
    @IBOutlet weak var hicnPrefix: UITextField!
    
    @IBOutlet var chartView: LineChartView!
    
    var index = Int(0)
    
    var timer = RepeatingTimer(timeInterval: 1  )
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "hIperf"
            
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        
    
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = 100
        leftAxis.axisMinimum = 0
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        chartView.rightAxis.enabled = false
        chartView.xAxis.enabled = false
        //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
        //[_chartView.viewPortHandler setMaximumScaleX: 2.f];

        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
            
   //         chartView.legend.form = .line
        chartView.legend.enabled = false
        
        initGraph()
    
    
    }

    override func updateChartData() {
        if self.shouldHideData {
        chartView.data = nil
            return
        }
        
        //self.setDataCount(Int(sliderX.value), range: UInt32(sliderY.value))
        self.initGraph()
    }
    
    func initGraph() {
        chartDataEntryArray = [ChartDataEntry]()
        values = [Int]()
        index = 0
        
        let set1 = LineChartDataSet(entries: chartDataEntryArray)
        set1.drawIconsEnabled = false
        
        set1.lineDashLengths = [5, 2.5]
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(.black)
        set1.setCircleColor(.black)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = 100
        leftAxis.axisMinimum = 0
        
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        set1.drawFilledEnabled = true
        chartView.xAxis.axisMinimum = Double(-30)
        chartView.xAxis.axisMaximum = Double(1)
        
        let data = LineChartData(dataSet: set1)
        
        chartView.data = data
    }
    
    func addData(_ value: Int) {
        print("index " + String(self.index))
        if chartDataEntryArray.count > 30 {
            chartDataEntryArray.remove(at: 0)
            values.remove(at: 0)
        }
        
        
        /*let formatter = DateFormatter()

        formatter.dateStyle = .long

        formatter.timeStyle = .medium

        formatter.timeZone = TimeZone.current


        let current = formatter.string(from: Date())


        let stringCurrent = formatter.date(from: current)

        let inMillis = stringCurrent!.timeIntervalSince1970*/
        //print(inMillis)
        //values = [ChartDataEntry]()
        chartDataEntryArray.append(ChartDataEntry(x: Double(index), y: Double(value)))
        values.append(value)
        let maxValue = values.max()
        chartView.xAxis.axisMinimum = Double(self.index - 30)
        chartView.xAxis.axisMaximum = Double(self.index + 1)
        //values.append(ChartDataEntry(x: Double(1), y: Double(10)))
        //values.append(ChartDataEntry(x: Double(2), y: Double(10)))

        let set1 = LineChartDataSet(entries: chartDataEntryArray)
        set1.drawIconsEnabled = false
        
        set1.lineDashLengths = [5, 2.5]
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(.black)
        set1.setCircleColor(.black)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = Double(maxValue! + 20)
        leftAxis.axisMinimum = 0
        chartView.data = data
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
        chartView.animate(xAxisDuration: 0)
        
    }
    
      /*  func setDataCount(_ count: Int, range: UInt32) {
            let values = (0..<count).map { (i) -> ChartDataEntry in
                let val = Double(arc4random_uniform(range) + 3)
                return ChartDataEntry(x: Double(i), y: val)
            }
            
            let set1 = LineChartDataSet(entries: values)
            set1.drawIconsEnabled = false
            
            set1.lineDashLengths = [5, 2.5]
            set1.highlightLineDashLengths = [5, 2.5]
            set1.setColor(.black)
            set1.setCircleColor(.black)
            set1.lineWidth = 1
            set1.circleRadius = 3
            set1.drawCircleHoleEnabled = false
            set1.valueFont = .systemFont(ofSize: 9)
            set1.formLineDashLengths = [5, 2.5]
            set1.formLineWidth = 1
            set1.formSize = 15
            
            let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                                  ChartColorTemplates.colorFromString("#ffff0000").cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            
            set1.fillAlpha = 1
            set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
            set1.drawFilledEnabled = true
            
            let data = LineChartData(dataSet: set1)
            
            chartView.data = data
            chartView.animate(xAxisDuration: 0)
        }*/
        


    @IBAction func startButton(_ sender: Any) {
        timer = RepeatingTimer(timeInterval: 1  )
        print(hicnPrefix.text!)
        var buffer: [CChar]?
        let queue = DispatchQueue(label: "hiperf")
        buffer = self.hicnPrefix.text?.cString(using: .utf8)
        queue.async {
            startHiperf(buffer, 0,0,0,1000,0, 1000)
        }
        self.index = 0
        
        DispatchQueue.main.async {
                   
            self.initGraph()
                       
        }
        
        timer.eventHandler = {
            DispatchQueue.main.async {
                //Do UI Code here.
                //Call Google maps methods.
                let value = getValue()
                self.addData(Int(value)) //self.index%100)
                self.index = self.index + 1
                
            }
            
        }
        timer.resume()
    }
    
    
    @IBAction func stopButton(_ sender: Any) {
        timer.suspend()
        
        stopHiperf()
    }
}
