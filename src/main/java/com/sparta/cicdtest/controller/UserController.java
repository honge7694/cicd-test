package com.sparta.cicdtest.controller;

import com.sparta.cicdtest.dto.RequestDto;
import com.sparta.cicdtest.dto.UserRequestDto;
import com.sparta.cicdtest.dto.UserResponseDto;
import com.sparta.cicdtest.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/users")
public class UserController {

    private final UserService userService;

    @PostMapping("/")
    public UserResponseDto createUser(@RequestBody UserRequestDto requestDto) {
        return userService.createUser(requestDto);
    }
}
