package com.exercise.stutodo_app.models;

import java.util.Date;

public class TaskModel {

    private String title;
    private String dueDate;
    private String note;
    private Date createdAt;
    private String taskID;
    private String isDone;
    private String uid;
    private String completedAt;

    public TaskModel(String title, String dueDate, String note, Date createdAt, String taskID, String isDone, String uid, String completedAt) {
        this.title = title;
        this.dueDate = dueDate;
        this.note = note;
        this.createdAt = createdAt;
        this.taskID = taskID;
        this.isDone = isDone;
        this.uid = uid;
        this.completedAt = completedAt;
    }

    public String getTitle() {
        return title;
    }

    public String getDueDate() {
        return dueDate;
    }

    public String getNote() {
        return note;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public String getTaskID() {
        return taskID;
    }

    public String getIsDone() {
        return isDone;
    }

    public String getUid() {
        return uid;
    }

    public String getCompletedAt() {
        return completedAt;
    }
}
