package com.exercise.stutodo_app.models;

import com.google.firebase.Timestamp;
import com.google.firebase.firestore.ServerTimestamp;

import java.util.Date;

public class TaskModel {

    private String title;
    private Date dueDate;
    //private Timestamp dueDate;
    private String note;
    private @ServerTimestamp Date createdAt;
    private String taskID;
    private boolean isDone;
    private String uid;
    private Date completedAt;

    public TaskModel() {
    }

    public TaskModel(String title, Date dueDate, String note, Date createdAt, String taskID, boolean isDone, String uid, Date completedAt) {

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

    public Date getDueDate() {
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

    public boolean getIsDone() {
        return isDone;
    }

    public String getUid() {
        return uid;
    }

    public Date getCompletedAt() {
        return completedAt;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public void setTaskID(String taskID) {
        this.taskID = taskID;
    }

    public void setIsDone(boolean isDone) {
        this.isDone = isDone;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public void setCompletedAt(Date completedAt) {
        this.completedAt = completedAt;
    }
}
