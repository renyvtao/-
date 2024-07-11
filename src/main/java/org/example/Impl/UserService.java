package org.example.Impl;

import org.example.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.UUID;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public ResponseEntity<User> login(String username, String password) {
        User user = userRepository.findByUsername(username);
        if (user == null || !password.equals(user.getPassword())) {
            return ResponseEntity.status(400).body(null); // User does not exist or incorrect password, login failed
        } else {
            return ResponseEntity.ok(user); // Login successful
        }
    }

    public ResponseEntity<User> register(User newUser) {
        User existingUser = userRepository.findByUsername(newUser.getUsername());
        if (existingUser != null) {
            return ResponseEntity.status(400).body(null); // Username already exists, registration failed
        } else {
            newUser.setId(UUID.randomUUID().toString()); // 使用UUID生成唯一ID
            newUser.setManagementLevel(0);
            userRepository.save(newUser);
            return ResponseEntity.ok(newUser); // Registration successful
        }
    }

    public ResponseEntity<User> updateUser(String id, User updatedUser) {
        User existingUser = userRepository.findById(id).orElse(null);
        if (existingUser == null) {
            return ResponseEntity.status(404).body(null); // 用户未找到
        } else {
            // 更新用户信息
            existingUser.setUsername(updatedUser.getUsername());
            existingUser.setEmail(updatedUser.getEmail());
            existingUser.setPassword(updatedUser.getPassword());
            existingUser.setAvatarUrl(updatedUser.getAvatarUrl());
            // 添加其他需要更新的字段

            userRepository.save(existingUser);
            return ResponseEntity.ok(existingUser); // 更新成功
        }
    }



}