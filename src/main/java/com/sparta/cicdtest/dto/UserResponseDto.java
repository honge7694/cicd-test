package com.sparta.cicdtest.dto;

import com.sparta.cicdtest.entity.User;
import lombok.Getter;

@Getter
public class UserResponseDto {
    private Long id;
    private String name;
    private String email;
    private String password;

    public UserResponseDto(User user) {
        this.id = user.getId();
        this.name = user.getName();
        this.email =user.getEmail();
        this.password = user.getPassword();
    }
}
