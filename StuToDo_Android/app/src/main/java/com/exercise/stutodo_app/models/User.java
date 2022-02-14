package com.exercise.stutodo_app.models;

public class User {

    private String uid;
    private String profileImageUrl;
    private String firstname;
    private String lastname;
    private String age;
    private String university;
    private String email;

    public User() {
    }

    public User(String uid, String profileImageUrl, String firstname, String lastname, String age, String university, String email) {
        this.uid = uid;
        this.profileImageUrl = profileImageUrl;
        this.firstname = firstname;
        this.lastname = lastname;
        this.age = age;
        this.university = university;
        this.email = email;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getProfileImageUrl() {
        return profileImageUrl;
    }

    public void setProfileImageUrl(String profileImageUrl) {
        this.profileImageUrl = profileImageUrl;
    }

    public String getFirstName() {
        return firstname;
    }

    public void setFirstName(String firstName) {
        this.firstname = firstName;
    }

    public String getLastName() {
        return lastname;
    }

    public void setLastName(String lastName) {
        this.lastname = lastName;
    }

    public String getAge() {
        return age;
    }

    public void setAge(String age) {
        this.age = age;
    }

    public String getUniversity() {
        return university;
    }

    public void setUniversity(String university) {
        this.university = university;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
