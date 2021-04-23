//
//  ContentView.swift
//  BetterRest
//
//  Created by Leotis buchanan on 2021-04-22.
//

/*
 This app is going to allow user input with a date picker and two steppers, which combined
 will tell us when they want to wake up, how much sleep they usually like, and how much
 coffee they drink.
 */

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    
    
     var computeSleepTime :String{
        
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from:wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        var formatted_sleep_time:String = ""
        
        do {
            let prediction  = try model.prediction(wake:Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            formatted_sleep_time =  formatter.string(from: sleepTime)
            
            alertTitle = "Your ideal bedtime is..."
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
            
        }
        
        return formatted_sleep_time
        
        
    }
    
    
    var body: some View {
        NavigationView {
            Form{
                
                Section{
                    Text("Recommended Bed Time")
                        .font(.headline)
                    
                    Text("\(computeSleepTime)").font(.largeTitle)
                }
                
                Section{
                    Text("When do you want to wake up")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection:$wakeUp,
                               displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section {
                    
                    Text("Daily coffee intake")
                        .font(.headline)
                    Stepper(value:$coffeeAmount, in: 1...20){
                        if coffeeAmount == 1 {
                            Text("1 cup")
                        } else {
                            Text("\(coffeeAmount) cups")
                        }
                    }
                }
            }.navigationTitle("BetterRest")
           
            
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
