//
//  ViewController2.swift
//  MusicAnalyzer
//
//  Created by Johnny Le on 4/29/16.
//  Copyright © 2016 Leviathan. All rights reserved.
//

import UIKit
import AudioKit
import AVFoundation
import MediaPlayer

class ViewController2: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Songs2"
        
        //playBackgroundMusic("")
        
        let sampler = AKSampler()
        
        sampler.loadPath("Summer.mp3")
        
        AudioKit.output = sampler
        
        AudioKit.start()
        
        //let audio = AKAudioPlayer("How Deep is Your Love.mp3")
        
        //audio.start()
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    var backgroundMusicPlayer = AVAudioPlayer()
    
//    func playBackgroundMusic(filename: String) {
//        let url = filename
//        do {
//            backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: url)
//            backgroundMusicPlayer.numberOfLoops = -1
//            backgroundMusicPlayer.prepareToPlay()
//            backgroundMusicPlayer.play()
//        } catch let error as NSError {
//            print(error.description)
//        }
//    }
    
    func queryMusic() {
        
        
        // All
        let mediaItems = MPMediaQuery.songsQuery().items
        
        
        // Or you can filter on various property
        //        // Like the Genre for example here
        //        let query = MPMediaQuery.songsQuery()
        //        let predicateByGenre = MPMediaPropertyPredicate(value: "Rock", forProperty: MPMediaItemPropertyGenre)
        //        query.filterPredicates = NSSet(object: predicateByGenre) as? Set<MPMediaPredicate>
        
        let mediaCollection = MPMediaItemCollection(items: mediaItems!)
        
        let player = MPMusicPlayerController.systemMusicPlayer()
        player.setQueueWithItemCollection(mediaCollection)
        
        player.play()
    }
    
    
    
}

