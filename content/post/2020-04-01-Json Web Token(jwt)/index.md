+++
title = "Json Web Token(jwt)"
date = 2020-04-01
draft = false
tags = ["JWT"]
categories = ["NOTE"]
+++

Json Web Token(jwt) (history note from hackMD)
===

[TOC]

###### tags: `JWT`,`Json Web Token`

## What is Jwt?
JWT 是基於 JSON 的開放標準 (RFC 7519)

一般被用來在 身份提供者 和 服務提供者 間傳遞被 認證 的用戶身份信息，以便於從資源伺服器獲取資源，同時也可以增加一些額外的聲明信息，該 token 也可直接被用於認證，也可被加密。

### 1.Jwt的組成
JWT 的組成內容有三個部分，由 **<font color="red"> . (dots)</font>** 做區隔
* **Header**
用來指定加密方法，通常系統是預設<font color="red"> HS256 </font>雜湊演算法來加密，官方也提供許多演算法加密也可以手動更改加密的演算法。
* **payload**
它和 Session 一樣，可以把一些自定義的數據存儲在 Payload裡例如像是用戶資料。
* **Signature**
做為檢查碼是為了預防前兩部分被中間人偽照修改或利用的機制。

最後表示法就像這樣
> <font color="blue">eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9</font>**.**<font color="green">eyJ1c2VyX25hbWUiOiJBbmR5MTAiLCJ1c2VyX21haWwiOiJhbmR5QGdtYWlsLmNvbSIsInVzZXJfcGFzc3dvcmQiOiJwYXNzd29yZDEwIiwiaWF0IjoxNTE1MTQwNDg0fQ</font>**.**<font color="red">P41UlFdYNIho2EA8T5k9iNK0EMC-Wn06RKk_0FFNjLo</font>

### 2.Why JWT?
JSON 比 XML 普及，相較之下結構也簡單，支援多種程式語言
可以儲存簡單但 非敏感 的商業邏輯訊息
構成內容簡單，佔用 Size 小方便傳輸
Stateless
可以降低 Server 保存 Session 的 loading
容易做到跨平台的應用擴展，如 SSO 應用
> 延伸閱讀:
> [一次搞懂OAuth與SSO在幹什麼?](https://studyhost.blogspot.com/2017/01/oauthsso.html)

### 3.優點
* 跨語言，因為 json 格式大部分語言都可使用
* 可儲存一些簡單但非敏感的商業邏輯 - role ..
* 構成內容簡單，佔用 Size 小方便傳輸
* 不需在 server 保存 session，所以它易於應用的擴展

### 4.安全相關 Security

* Base64 只是一種編碼方式，所以 JWT 不適合儲存敏感訊息。也就是說 JWT 的 Token 內容是可以被解析的。
* 用來加密的 Secret 要保存在 Server 不應外流。
* 請使用<font color="red"> Https</font> 確保在授權的時候不會被竊聽。
* 建議開啟 Http only 防止 Token 被擷取，這也是常見的來 XSS 防護方法之一。

### 5.常見問題
* JWT 安全嗎?
Base64 編碼方式是可逆的，也就是透過編碼後發放的 Token 內容是可以被解析的。
一般而言，我們都不建議在 Payload 內放敏感訊息，比如使用者的密碼。

* JWT Payload 內容可以被偽造嗎？
JWT 其中的一個組成內容為 Signature，可以防止藉由 Base64 可逆方法回推 payload 內容並將其修改。
因為 Signature 是經由 Header 跟 Payload 一起 Base64 組成的。當然如果你的加密的金鑰 (secret) 流失， 便可經由第三方自行重置合法的 Token 導致失去驗證授權與否的效益。

* 如果我的 Cookie 被竊取了，那不就表示第三方可以做 CSRF 攻擊?
是的，Cookie 掉了，就表示身份就可以被偽造。故官方建議的使用方式是存放在 LocalStorage 中，並使用 Header 送出。

### 6.JWT的工作流程

下面是一個JWT的工作流程圖。
![](https://i.imgur.com/TdxKylr.jpg)

#### 模擬一下實際的流程是這樣的...（假設受保護的API在/protected中）

1. 使用者導引到登錄頁面，輸入使用者名稱、密碼，進行登錄
1. 伺服器驗證登錄資訊，如果通過，根據使用者資訊和伺服器的規則產生一組JWT Token
1. 伺服器將該token以json形式回傳（不一定要json形式，這裡說的是一種常見的做法）
1. 使用者得到token，存在localStorage、cookie或其它資料儲存形式之中。
1. 以後用戶請求/protected中的API時，在請求的header中加入Authorization: Bearer xxxx(token)。<font color="red">(此處注意token之前有一個"7"字符長度的 "Bearer ")</font>
1. 服務器端對此token進行檢驗，如果合法就解析其中內容，根據其擁有的權限和自己的業務邏輯給出對應的響應結果。 
1. 用戶取得回傳結果。

## 使用Spring Boot + Security + JPA + JWT + MySQL Hello World實作範例
> Project structure
> IDE: IntelliJ 
> Java version: 8
> Framework: SpringBoot 2.5.5 Release
> DB: MySql
> Build Tools: Maven

### 專案結構

![](https://i.imgur.com/w13cmpc.jpg)

### Step 1: 建立Hello world Maven專案

#### Pom.xml

引入必要的dependencies

* SpringBootStarterWeb
* Security
* JPA
* Jwt
* MySqlconnector

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>jwt</artifactId>
    <version>1.0-SNAPSHOT</version>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.2.5.RELEASE</version>
        <relativePath/>
    </parent> <!-- lookup parent from repository -->

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt</artifactId>
            <version>0.9.1</version>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
```
#### application.propreties

* DB資訊
* jpa自動生成Schema
* jwt Secret Key

```yml
# URL-encode %2B = + 
spring.datasource.url=jdbc:mysql://localhost:3306/DBName?useUnicode=true&characterEncoding=UTF-8&serverTimezone=GMT%2B8
spring.datasource.username=root
spring.datasource.password=
spring.datasource.driver-class-name=com.mysql.jdbc.Driver

spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.jdbc.time_zone=GMT+08:00
spring.jpa.hibernate.use-new-id-generator-mappings=true

spring.security.user.name=admin
spring.security.user.password=123456

jwt.secret=javainuse

```
### Step1: 建立一個簡單的Hello World專案

#### TestController
建一隻Controller以便後續測試取得合法Jwt Token後呼叫Rest GET API是否可成功收到Hello World!(此範例就不再示範Service層實作)

```java
package com.rex.demo.controller;

import com.rex.demo.service.ITestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api/test")
public class TestController {

    @Autowired
    ITestService iTestService;

    @GetMapping(value = "get")
    public String get() {
        return iTestService.call();
    }
}

```

#### UserEntity
建置Entity與DB映射
```java
package com.rex.demo.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import javax.persistence.*;

@Entity
@Table(name = "user")
public class UserEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column
    private String username;
    @Column
    @JsonIgnore
    private String password;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}

```
#### UserRequest
傳入使用Model
```java
package com.rex.demo.model.request;

public class UserRequest {
    
    private String username;
    
    private String password;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}

```

### Step2: 配置 SpringSecurity 和 JWT

這裡設定繁多，所以使用程式碼內註解來說明簡短篇幅

#### JwtTokenUtil

為Jwt建置一個工具類別,這個工具類別則是用來進行Jwt事務像是創建或是驗證Token
詳細解說在Code裡面說明

```java
package com.rex.demo.utils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Component
public class JwtTokenUtil implements Serializable {
    private static final long serialVersionUID = -2550185165626007488L;

    public static final long JWT_TOKEN_VALIDITY = 5 * 60 * 60;

    @Value("${jwt.secret}")
    private String secret;

    //從Token取得使用者
    public String getUsernameFromToken(String token) {
        return getClaimFromToken(token, Claims::getSubject);
    }

    //從Token取得截止日期
    public Date getExpirationDateFromToken(String token) {
        return getClaimFromToken(token, Claims::getExpiration);
    }

    //取得Token聲明
    public <T> T getClaimFromToken(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = getAllClaimsFromToken(token);
        return claimsResolver.apply(claims);
    }

    //使用Secret Key取得Token裡的所有資訊
    private Claims getAllClaimsFromToken(String token) {
        return Jwts.parser().setSigningKey(secret).parseClaimsJws(token).getBody();
    }

    //使用者 Token
    public String generateToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        return doGenerateToken(claims, userDetails.getUsername());
    }

    //創建Token三部曲:
    //1. 定義Token聲明(發行者, 截止日期, 用途 和 Id)
    //2. 使用 HS512 算法和Secret Key對Jwt簽署.
    //3. 根據JWS Compat序列化將JWT與URL-safe結合成一個字串
    private String doGenerateToken(Map<String, Object> claims, String subject) {
        return Jwts.builder().setClaims(claims).setSubject(subject).setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + JWT_TOKEN_VALIDITY * 1000))
                .signWith(SignatureAlgorithm.HS512, secret).compact();
    }

    //驗證Token是否過期
    private Boolean isTokenExpired(String token) {
        final Date expiration = getExpirationDateFromToken(token);
        return expiration.before(new Date());
    }

    //Token 驗證使用者名稱與密碼是否正確和Token是否過期
    public Boolean validateToken(String token, UserDetails userDetails) {
        final String username = getUsernameFromToken(token);
        return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
    }
}

```
#### JWTUserDetailsService
此類別將實作Spring Security UserDetailService Interface
* 覆寫loadUserByUsername ,Spring Security Authentication Manager 呼叫這支方法來取得DB內的使用者資訊 
* 新增一隻方法save做新增使用者資訊,密碼則用bcrypt作加密
```java=
package com.rex.demo.config;

import com.rex.demo.entity.UserEntity;
import com.rex.demo.model.request.UserRequest;
import com.rex.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.ArrayList;


@Service
public class JwtUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder bcryptEncoder;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        UserEntity userEntity = userRepository.findByUsername(username);
        if (userEntity == null){
            throw new UsernameNotFoundException("User not found with username: " + username);
        }
        //注意!! 這裡使用的建構子是Security的userdetails.User 並非自己建置的User
        //參數 使用者名稱 , 密碼 , 權限(這裡不指定權限所以塞空List)
        //org.springframework.security.core.userdetails.User(String username, String password, Collection<? extends GrantedAuthority> authorities)
        return new User(userEntity.getUsername(),userEntity.getPassword(),new ArrayList<>());
    }

    public UserEntity save(UserRequest userRequest){
        UserEntity newUser = new UserEntity();
        newUser.setUsername(userRequest.getUsername());
        newUser.setPassword(bcryptEncoder.encode(userRequest.getPassword()));
        return userRepository.save(newUser);
    }
}

```

#### JwtAuthenticationController

新增一隻POST API /authentication 來取得request 的username 和 password,Spring Authentication Manager會對其進行驗證,如果驗證成功,就會使用JwtTokenUtil來創造一組JwtToken並回傳

```java
package com.rex.demo.controller;

import com.rex.demo.utils.JwtTokenUtil;
import com.rex.demo.config.JwtUserDetailsService;
import com.rex.demo.model.request.JwtRequest;
import com.rex.demo.model.request.UserRequest;
import com.rex.demo.model.response.JwtResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin
public class JwtAuthenticationController {
    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    @Autowired
    private JwtUserDetailsService jwtUserDetailsService;

    @PostMapping(value = "/authenticate")
    public ResponseEntity<?> createAuthenticationToken(@RequestBody JwtRequest authenticationRequest) throws Exception {

        authenticate(authenticationRequest.getUsername(), authenticationRequest.getPassword());

        final UserDetails userDetails = jwtUserDetailsService.loadUserByUsername(authenticationRequest.getUsername());

        final String token = jwtTokenUtil.generateToken(userDetails);

        return ResponseEntity.ok(new JwtResponse(token));
    }

    @RequestMapping(value = "/register",method = RequestMethod.POST)
    public ResponseEntity<?> saveUser(@RequestBody UserRequest userRequest) throws Exception{
        return ResponseEntity.ok(jwtUserDetailsService.save(userRequest));
    }

    private void authenticate(String username, String password) throws Exception {
        try {
            authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(username, password));
        } catch (DisabledException e) {
            throw new Exception("USER_DISABLED", e);
        } catch (BadCredentialsException e) {
            throw new Exception("INVALID_CREDENTIALS", e);
        }
    }
}

```
#### JwtRequest

Request Model

```java
package com.rex.demo.model.request;

import java.io.Serializable;

public class JwtRequest implements Serializable {
    private static final long serialVersionUID = 5926468583005150707L;
    private String username;
    private String password;

    //need default constructor for JSON Parsing
    public JwtRequest() {
    }

    public JwtRequest(String username, String password) {
        this.setUsername(username);
        this.setPassword(password);
    }

    public String getUsername() {
        return this.username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return this.password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
```
#### JwtResponse

Response Model

```java=
package com.rex.demo.model.response;

import java.io.Serializable;

public class JwtResponse implements Serializable {
    private static final long serialVersionUID = -8091879091924046844L;
    private final String jwttoken;

    public JwtResponse(String jwttoken) {
        this.jwttoken = jwttoken;
    }

    public String getToken() {
        return this.jwttoken;
    }
}

```

#### JwtRequestFilter

建立一支Filter提供Jwt進行身分驗證,此類別繼承OncePerRequestFilter,確認Request是否擁有合法Token,如果有的話則設定Authentication 到Context裡面,這樣才會通過Spring Security的驗證程序
```java
package com.rex.demo.config;

import com.rex.demo.utils.JwtTokenUtil;
import io.jsonwebtoken.ExpiredJwtException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class JwtRequestFilter extends OncePerRequestFilter {
    @Autowired
    private JwtUserDetailsService jwtUserDetailsService;
    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        final String requestTokenHeader = request.getHeader("Authorization");
        String username = null;
        String jwtToken = null;
        // 把"Bearer "去除只拿Token部分
        if (requestTokenHeader != null && requestTokenHeader.startsWith("Bearer ")) {
            jwtToken = requestTokenHeader.substring(7);
            try {
                username = jwtTokenUtil.getUsernameFromToken(jwtToken);
            } catch (IllegalArgumentException e) {
                System.out.println("Unable to get JWT Token");
            } catch (ExpiredJwtException e) {
                System.out.println("JWT Token has expired");
            }
        } else {
            logger.warn("JWT Token does not begin with Bearer String");
        }
        // 拿到Token即對其進行驗證
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            UserDetails userDetails = this.jwtUserDetailsService.loadUserByUsername(username);
            // 如果當前Token是一個有效Token,則進行手動設置一個Spring Security authentication 
            if (jwtTokenUtil.validateToken(jwtToken, userDetails)) {
                UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken = new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities());
                usernamePasswordAuthenticationToken
                        .setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                // 在我們設定一個Authentication到Context確保當前使用者是已驗證狀態,這樣才會通過Spring Security的驗證程序
                SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);
            }
        }
        chain.doFilter(request, response);
    }
}

```
JwtAuthenticationEntryPoint
此類別繼承 AuthenticationEntryPoint，覆寫commence。任何未授權的Request都會回傳erroe code 401
```java
package com.rex.demo.config;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Serializable;

@Component
public class JwtAuthenticationEntryPoint implements AuthenticationEntryPoint, Serializable {

    private static final long serialVersionUID = -7858869558953243875L;

    @Override
    public void commence(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, AuthenticationException e) throws IOException, ServletException {
        httpServletResponse.sendError(HttpServletResponse.SC_UNAUTHORIZED,"Unauthorized");
    }
}

```

WebSecurityConfig

```java
package com.rex.demo.config;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig {

    @Order(1)
    @Configuration
    @EnableGlobalMethodSecurity(prePostEnabled = true, securedEnabled = true, jsr250Enabled = true)
    public static class ApiConfig extends WebSecurityConfigurerAdapter {
        @Autowired
        private JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;

        @Autowired
        private JwtUserDetailsService jwtUserDetailsService;

        @Autowired
        private JwtRequestFilter jwtRequestFilter;

        @Autowired
        public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
            // 配置 AuthenticationManager so that it knows from where to load
            // user for matching credentials
            // Use BCryptPasswordEncoder
            auth.userDetailsService(jwtUserDetailsService).passwordEncoder(passwordEncoder());
        }

        @Bean
        public PasswordEncoder passwordEncoder() {
            return new BCryptPasswordEncoder();
        }

        @Bean
        @Override
        public AuthenticationManager authenticationManagerBean() throws Exception {
            return super.authenticationManagerBean();
        }

        @Override
        protected void configure(HttpSecurity httpSecurity) throws Exception {
            // 關閉csrf防護
            httpSecurity.csrf().disable()
                    // 不驗證
                    .authorizeRequests().antMatchers("/authenticate","/register").permitAll().
                    // all other requests need to be authenticated
                            anyRequest().authenticated().and().
                    // make sure we use stateless session; session won't be used to
                    // store user's state.
                            exceptionHandling().authenticationEntryPoint(jwtAuthenticationEntryPoint).and().sessionManagement()
                    .sessionCreationPolicy(SessionCreationPolicy.STATELESS);
            // Add a filter to validate the tokens with every request
            httpSecurity.addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class);
        }
    }

    @Order(2)
    @Configuration
    public static class WebSocket extends WebSecurityConfigurerAdapter {
        @Override
        public void configure(HttpSecurity http) throws Exception {
            http.cors().and().csrf().disable().antMatcher("/websocket*").authorizeRequests().anyRequest().permitAll();
        }
    }
}

```
