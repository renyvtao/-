package org.example.Impl;


import org.example.entity.Song;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class SongService {

    @Autowired
    private SongRepository songRepository;

    public Song addSong(Song song) {
        if (song.getId() == null || song.getId().isEmpty()) {
            song.setId(UUID.randomUUID().toString());
        }
        return songRepository.save(song);
    }

    public Song updateSong(Song song) {
        return songRepository.save(song);
    }

    public void deleteSong(String id) {
        songRepository.deleteById(id);
    }

    public Optional<Song> getSongById(String id) {
        return songRepository.findById(id);
    }

    public List<Song> getAllSongs() {
        return songRepository.findAll();
    }

    public Page<Song> getSongsByPage(Pageable pageable) {
        return songRepository.findAll(pageable);
    }
}
