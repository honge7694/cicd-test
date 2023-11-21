package com.sparta.cicdtest.repository;

import com.sparta.cicdtest.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}
