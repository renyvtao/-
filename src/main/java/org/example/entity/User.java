package org.example.entity;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.util.UUID;

@Entity
@Table(name = "users")
public class User {

    @Id
    private String id;
    private String username;
    private String email;
    private String password;
    private String avatarUrl;
    private int managementLevel;

    public User() {
        // 使用随机生成的UUID作为ID
        this.id = UUID.randomUUID().toString();
    }

    public User(String username, String email, String password, String avatarUrl, int managementLevel) {
        this(); // 调用默认构造函数生成ID
        this.username = username;
        this.email = email;
        this.password = password;
        this.avatarUrl = avatarUrl;
        this.managementLevel = managementLevel;
    }

    // Getter和Setter方法
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public int getManagementLevel() {
        return managementLevel;
    }

    public void setManagementLevel(int managementLevel) {
        this.managementLevel = managementLevel;
    }
}
