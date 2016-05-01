//
//  SongQuery.swift
//  MusicAnalyzer
//
//  Created by Johnny Le on 4/30/16.
//  Copyright © 2016 Leviathan. All rights reserved.
//

import Foundation
import MediaPlayer

//
struct SongInfo {
    
    var albumTitle: String
    var artistName: String
    var songTitle:  String
    
    var songId   :  NSNumber
}

struct AlbumInfo {
    
    var albumTitle: String
    var songs: [SongInfo]
}

class SongQuery {
    
    func get() -> [AlbumInfo] {
        
        var albums: [AlbumInfo] = []
        
        let albumsQuery: MPMediaQuery = MPMediaQuery.albumsQuery()
        let albumItems: [MPMediaItemCollection] = albumsQuery.collections! as [MPMediaItemCollection]
        var album: MPMediaItemCollection
        
        for album in albumItems {
            
            var albumItems: [MPMediaItem] = album.items as [MPMediaItem]
            var song: MPMediaItem
            
            var songs: [SongInfo] = []
            
            var albumTitle: String = ""
            
            for song in albumItems {
                
                albumTitle = song.valueForProperty( MPMediaItemPropertyAlbumTitle ) as! String
                
                var songInfo: SongInfo = SongInfo(
                    albumTitle: song.valueForProperty( MPMediaItemPropertyAlbumTitle ) as! String,
                    artistName: song.valueForProperty( MPMediaItemPropertyArtist ) as! String,
                    songTitle:  song.valueForProperty( MPMediaItemPropertyTitle ) as! String,
                    songId:     song.valueForProperty( MPMediaItemPropertyPersistentID ) as! NSNumber
                )
                
                songs.append( songInfo )
            }
            
            var albumInfo: AlbumInfo = AlbumInfo(
                
                albumTitle: albumTitle,
                songs: songs
            )
            
            albums.append( albumInfo )
        }
        
        return albums
        
    }
    
    func getItem( songId: NSNumber ) -> MPMediaItem {
        
        var property: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: songId, forProperty: MPMediaItemPropertyPersistentID )
        
        var query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate( property )
        
        var items: [MPMediaItem] = query.items! as [MPMediaItem]
        
        return items[items.count - 1]
        
    }
    
}