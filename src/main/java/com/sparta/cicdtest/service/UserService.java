package com.sparta.cicdtest.service;

import com.sparta.cicdtest.dto.UserRequestDto;
import com.sparta.cicdtest.dto.UserResponseDto;
import com.sparta.cicdtest.entity.User;
import com.sparta.cicdtest.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;


    public UserResponseDto createUser(UserRequestDto requestDto) {
        User user = new User(requestDto);
        userRepository.save(user);
        return new UserResponseDto(user);
    }
}
