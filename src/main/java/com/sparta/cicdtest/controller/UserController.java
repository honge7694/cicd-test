package com.sparta.cicdtest.controller;

import com.sparta.cicdtest.dto.UserRequestDto;
import com.sparta.cicdtest.dto.UserResponseDto;
import com.sparta.cicdtest.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/users")
public class UserController {

    private final UserService userService;

    @PostMapping("/")
    public UserResponseDto createUser(@RequestBody UserRequestDto requestDto) {
        return userService.createUser(requestDto);
    }

    @GetMapping("/")
    public String asdf() {
        return "hello world 22222222222222";
    }
}
