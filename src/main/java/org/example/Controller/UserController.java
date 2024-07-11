package org.example.Controller;

import org.example.Impl.UserService;
import org.example.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public ResponseEntity<User> login(@RequestBody User user) {
        return userService.login(user.getUsername(), user.getPassword());
    }

    @PostMapping("/register")
    public ResponseEntity<User> register(@RequestBody User newUser) {
        return userService.register(newUser);
    }

    @PutMapping("/update_user/{id}")
    public ResponseEntity<User> updateUser(@PathVariable String id, @RequestBody User updatedUser) {
        return userService.updateUser(id, updatedUser);
    }
}
