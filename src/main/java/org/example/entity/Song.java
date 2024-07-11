package org.example.entity;

import javax.persistence.Entity;
import javax.persistence.Id;
import java.util.UUID;

@Entity
public class Song {

    @Id
    private String id;
    private String songName;
    private String artistName;
    private String albumArtImagePath;
    private String audioPath;
    private Boolean isFavorited;

    public Song() {
        this.id = UUID.randomUUID().toString();
    }

    public Song(String songName, String artistName, String albumArtImagePath, String audioPath, Boolean isFavorited) {
        this.id = UUID.randomUUID().toString(); // 使用随机生成的UUID作为ID
        this.songName = songName;
        this.artistName = artistName;
        this.albumArtImagePath = albumArtImagePath;
        this.audioPath = audioPath;
        this.isFavorited = isFavorited;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSongName() {
        return songName;
    }

    public void setSongName(String songName) {
        this.songName = songName;
    }

    public String getArtistName() {
        return artistName;
    }

    public void setArtistName(String artistName) {
        this.artistName = artistName;
    }

    public String getAlbumArtImagePath() {
        return albumArtImagePath;
    }

    public void setAlbumArtImagePath(String albumArtImagePath) {
        this.albumArtImagePath = albumArtImagePath;
    }

    public String getAudioPath() {
        return audioPath;
    }

    public void setAudioPath(String audioPath) {
        this.audioPath = audioPath;
    }

    public Boolean getIsFavorited() {
        return isFavorited;
    }

    public void setIsFavorited(Boolean isFavorited) {
        this.isFavorited = isFavorited;
    }
}
