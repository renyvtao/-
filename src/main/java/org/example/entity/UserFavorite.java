package org.example.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Objects;

@Entity
@Table(name = "user_favorites")
@IdClass(UserFavoriteId.class)
public class UserFavorite {
    @Id
    @Column(name = "user_id")
    private String userId;

    @Id
    @Column(name = "song_id")
    private String songId;

    // Constructors, getters, and setters
    public UserFavorite() {
    }

    public UserFavorite(String userId, String songId) {
        this.userId = userId;
        this.songId = songId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getSongId() {
        return songId;
    }

    public void setSongId(String songId) {
        this.songId = songId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserFavorite that = (UserFavorite) o;
        return Objects.equals(userId, that.userId) &&
                Objects.equals(songId, that.songId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, songId);
    }
}


