//
//  ViewController.swift
//  MusicAnalyzer
//
//  Created by Johnny Le on 4/29/16.
//  Copyright © 2016 Leviathan. All rights reserved.
//

import UIKit
import AudioKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet var tableView : UITableView?
    let myTableView: UITableView = UITableView( frame: CGRectZero, style: .Grouped )
    
    var albums: [AlbumInfo] = []
    var songQuery: SongQuery = SongQuery()
    var audio: AVAudioPlayer! = nil
    
    var osc: AKOscillator?
    var frequency: UISlider?
    var parser: NSXMLParser?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Songs"
        
        let stopButton: UIBarButtonItem = UIBarButtonItem( title: "Stop", style:  UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.stop) )
        
        self.navigationItem.rightBarButtonItem = stopButton
        
        let urlpath = NSBundle.mainBundle().pathForResource("Summer", ofType: "mp3")
        let url:NSURL = NSURL.fileURLWithPath(urlpath!)
        parser = NSXMLParser(contentsOfURL: url)!
        //parser!.delegate = self
        parser!.parse()
        
        
        osc = AKOscillator()
        
        albums = songQuery.get()
        
        AudioKit.output = osc
        
        AudioKit.start()
        
        //osc?.start()
        
        let freqRect: CGRect = CGRectMake(100, 100, 300, 100)
        
        frequency = UISlider(frame: freqRect)
        
        frequency!.addTarget(self, action: #selector(ViewController.knobValueChanged), forControlEvents: .ValueChanged)
//        wLabel.text = "Width"
//        wLabel.textColor = UIColor.whiteColor()
//        wLabel.font = UIFont(name: "Impact", size: CGFloat(10))
//        wLabel.textAlignment = .Center
//        
        view.addSubview(frequency!)
        
    }
    
    func knobValueChanged()
    {
        osc?.frequency = Double(frequency!.value * 880.0)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    func numberOfSectionsInTableView( tableView: UITableView ) -> Int {
        
        return albums.count
    }
    
    func tableView( tableView: UITableView, numberOfRowsInSection section: Int ) -> Int  {
        
        return albums[section].songs.count
    }
    
    func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath ) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell( style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell" )
        
        cell.textLabel!.text = albums[indexPath.section].songs[indexPath.row].songTitle
        cell.detailTextLabel!.text = albums[indexPath.section].songs[indexPath.row].artistName
        
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell;
    }
    
    func tableView( tableView: UITableView, titleForHeaderInSection section: Int ) -> String? {
        
        return albums[section].albumTitle
    }
    
    func tableView( tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath ) {
        
        let songId: NSNumber = albums[indexPath.section].songs[indexPath.row].songId
        let item: MPMediaItem = songQuery.getItem( songId )
        
        let url: NSURL = item.valueForProperty( MPMediaItemPropertyAssetURL ) as! NSURL
        
        playBackgroundMusic(url)
        
        self.title = albums[indexPath.section].songs[indexPath.row].songTitle
    }
    
    func stop() {
        
        if audio != nil {
            
            audio.stop()
            self.title = "Songs"
        }
        
    }
    
    var backgroundMusicPlayer = AVAudioPlayer()
    
    func playBackgroundMusic(filename: NSURL) {
        let url = filename
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: url)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
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

