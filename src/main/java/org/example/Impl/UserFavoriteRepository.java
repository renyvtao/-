package org.example.Impl;


import org.example.entity.UserFavorite;
import org.example.entity.UserFavoriteId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserFavoriteRepository extends JpaRepository<UserFavorite, UserFavoriteId> {
    List<UserFavorite> findByUserId(String userId);
    Optional<UserFavorite> findByUserIdAndSongId(String userId, String songId);
}
