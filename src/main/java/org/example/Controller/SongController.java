package org.example.Controller;


import org.example.entity.Song;
import org.example.Impl.SongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/songs")
public class SongController {

    @Autowired
    private SongService songService;

    @PostMapping
    public ResponseEntity<Song> addSong(@RequestBody Song song) {
        Song newSong = songService.addSong(song);
        return new ResponseEntity<>(newSong, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Song> updateSong(@PathVariable String id, @RequestBody Song song) {
        if (!songService.getSongById(id).isPresent()) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        song.setId(id);
        Song updatedSong = songService.updateSong(song);
        return new ResponseEntity<>(updatedSong, HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSong(@PathVariable String id) {
        if (!songService.getSongById(id).isPresent()) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        songService.deleteSong(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Song> getSongById(@PathVariable String id) {
        Optional<Song> song = songService.getSongById(id);
        return song.map(ResponseEntity::ok)
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @GetMapping
    public ResponseEntity<List<Song>> getAllSongs() {
        List<Song> songs = songService.getAllSongs();
        return new ResponseEntity<>(songs, HttpStatus.OK);
    }

    @GetMapping("/page")
    public ResponseEntity<Page<Song>> getSongsByPage(@RequestParam int page, @RequestParam int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Song> songPage = songService.getSongsByPage(pageable);
        return new ResponseEntity<>(songPage, HttpStatus.OK);
    }
}
