package org.example.Impl;


import org.example.entity.Song;
import org.example.entity.UserFavorite;
import org.example.entity.UserFavoriteId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UserFavoriteService {

    @Autowired
    private UserFavoriteRepository userFavoriteRepository;
    @Autowired
    private SongRepository songRepository;

    public UserFavorite addFavorite(String userId, String songId) {
        UserFavorite favorite = new UserFavorite(userId, songId);
        return userFavoriteRepository.save(favorite);
    }

    public void removeFavorite(String userId, String songId) {
        UserFavoriteId userFavoriteId = new UserFavoriteId(userId, songId);
        userFavoriteRepository.deleteById(userFavoriteId);
    }

    public List<Song> getFavoriteSongs(String userId) {
        List<UserFavorite> favorites = userFavoriteRepository.findByUserId(userId);
        return favorites.stream().map(favorite -> {
            Optional<Song> songOpt = songRepository.findById(favorite.getSongId());
            return songOpt.orElse(null); // Or handle this case appropriately
        }).collect(Collectors.toList());
    }

    public boolean isFavorite(String userId, String songId) {
        return userFavoriteRepository.findByUserIdAndSongId(userId, songId).isPresent();
    }
}
