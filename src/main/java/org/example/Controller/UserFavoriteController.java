package org.example.Controller;


import org.example.Impl.UserFavoriteService;
import org.example.entity.Song;
import org.example.entity.UserFavorite;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/favorites")
public class UserFavoriteController {

    @Autowired
    private UserFavoriteService userFavoriteService;

    @PostMapping("/{userId}/{songId}")
    public ResponseEntity<UserFavorite> addFavorite(@PathVariable String userId, @PathVariable String songId) {
        UserFavorite favorite = userFavoriteService.addFavorite(userId, songId);
        return ResponseEntity.ok(favorite);
    }

    @DeleteMapping("/{userId}/{songId}")
    public ResponseEntity<Void> removeFavorite(@PathVariable String userId, @PathVariable String songId) {
        userFavoriteService.removeFavorite(userId, songId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{userId}")
    public ResponseEntity<List<Song>> getUserFavorites(@PathVariable String userId) {
        List<Song> favoriteSongs = userFavoriteService.getFavoriteSongs(userId);
        return ResponseEntity.ok(favoriteSongs);
    }

    @GetMapping("/{userId}/{songId}/isFavorite")
    public ResponseEntity<Boolean> isFavorite(@PathVariable String userId, @PathVariable String songId) {
        boolean isFavorite = userFavoriteService.isFavorite(userId, songId);
        return ResponseEntity.ok(isFavorite);
    }
}
