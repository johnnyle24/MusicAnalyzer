//
//  ViewController3.swift
//  MusicAnalyzer
//
//  Created by Johnny Le on 5/1/16.
//  Copyright © 2016 Leviathan. All rights reserved.
//

import UIKit
import MediaPlayer
import AudioKit

class ViewController3: UIViewController, MPMediaPickerControllerDelegate {
    
    var chosenCollection: MPMediaItemCollection!
    var chosenSong: MPMediaItem!
    var meterTable: MeterTable!
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Set up the media picker controller
        let picker = MPMediaPickerController.self(mediaTypes: MPMediaType.Music)
        picker.allowsPickingMultipleItems = false
        picker.delegate = self
        
        meterTable = MeterTable()
        
        // Present the media picker controller
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    /*
     * This method is called when the user chooses something from the media picker screen. It dismisses the media picker screen
     * and plays the selected song.
     */
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        // remove the media picker screen
        self.dismissViewControllerAnimated(true, completion:nil)
        chosenCollection = mediaItemCollection
        exportSong()
    }
    
    /*
     * This method is called when the user cancels out of the media picker. It just dismisses the media picker screen.
     */
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        
        // remove the media picker screen
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    func exportSong() {
        // Get the song from the collection. Multiple songs can be chosen if
        // allowsPickingMultipleItems is set to true
        chosenSong = chosenCollection.items[0]
        
        if (chosenSong == nil)
        {
            print(chosenSong)
        }
        
        // Set up the export
        let filename = "exported.mp4"
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let exportedFileURL = documentsDirectory.URLByAppendingPathComponent(filename)
        print("saving to \(exportedFileURL.absoluteString)")
        
        // Delete existing exported song, i.e. from previous app boot
        let filemanager = NSFileManager.defaultManager()
        
        do {
            try filemanager.removeItemAtURL(exportedFileURL)
            print("Existing file deleted")
        } catch {
            print("No file to delete")
        }
        
        // Set up the export
        
        let url = chosenSong.valueForProperty(MPMediaItemPropertyAssetURL) as! NSURL
        
        let songAsset = AVAsset(URL: url)
        
        // Export as a .m4a file preset
        let exporter = AVAssetExportSession(asset: songAsset, presetName: AVAssetExportPresetAppleM4A)!
        exporter.outputFileType = AVFileTypeAppleM4A
        exporter.outputURL = exportedFileURL
        
        // Set the length of the export to be the length of the song
        let duration = CMTimeGetSeconds(songAsset.duration)
        let endTime = Int64(duration)
        let startTime = CMTimeMake(0, 1)
        let stopTime = CMTimeMake(endTime, 1)
        let exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime)
        exporter.timeRange = exportTimeRange
        
        // Do the export. If the export succeeds then play the song
        exporter.exportAsynchronouslyWithCompletionHandler({
            
            if exporter.status == AVAssetExportSessionStatus.Failed {
                print("Export failed \(exporter.error)")
            } else if exporter.status == AVAssetExportSessionStatus.Cancelled {
                print("Export cancelled \(exporter.error)")
            } else if exporter.status == AVAssetExportSessionStatus.Unknown {
                print("Export unknown \(exporter.error)")
            } else {
                print("Export complete")
                self.playSong(exportedFileURL)
            }
        })
    }
    
    // Function to play the song through AudioKit
    func playSong(songToPlay: NSURL) {
        //let songPath = songToPlay.path!
        
        do {
            try player = AVAudioPlayer(contentsOfURL: songToPlay, fileTypeHint: ".mp4")
        }
        catch{
            print("error loading")
        }

        
        player.updateMeters()
        player.meteringEnabled = true
        
//        AudioKit.output = player
//        AudioKit.start()
        
        
        //let result = AKLowPassFilter(sampler)
        
        print("AudioKit Start")
        
        player.prepareToPlay()
        player.play()
        
        //Keep playing this song over and over! Go to settings for background music on home screen
//        player.looping = true
        
        print("Player About to Play")
        
        //let audioAmp = AKAmplitudeTracker(player)
        
        while(player.playing)
        {
            update()
        }
    }
    
    func update()
    {
        // 1
        var scale: Float = 0.5;
        
        player.volume = 0
        
        if (player.playing )
        {
            // 2
            player.updateMeters()
            
            // 3
            var power: Float = Float(0.0);
            for i in 0...player.numberOfChannels-1 {
                power += player.averagePowerForChannel(i)
                
                print("Power= \(power)")
            }
            power /= Float(player.numberOfChannels)
            
            print("Power float= \(power)")
            
            // 4
            let level: Float = meterTable.ValueAt(power);
            
            print("Level= \(level)")
            
            scale = level * 5;
            
        }
        
        // 5
        //[emitterLayer setValue:@(scale) forKeyPath:@"emitterCells.cell.scale"];
        
        print(scale)
    }
}