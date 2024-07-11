package org.example.entity;

import java.io.Serializable;
import java.util.Objects;

public class UserFavoriteId implements Serializable {
    private String userId;
    private String songId;

    // Constructors, getters, setters, equals, and hashCode
    public UserFavoriteId() {
    }

    public UserFavoriteId(String userId, String songId) {
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
        UserFavoriteId that = (UserFavoriteId) o;
        return Objects.equals(userId, that.userId) &&
                Objects.equals(songId, that.songId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, songId);
    }
}