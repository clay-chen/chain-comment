pragma solidity ^0.4.19;

import "./Ownable.sol";

contract CommentFactory is Ownable {
    // 分值（1-10） 评论内容
    struct Comment {
        uint8 score;
        string contect;
        uint weight;
    }

    // 节目
    struct Program {
        string name;
    }

    Comment[] comments;
    Program[] programs;

    // 评论与人员关系
    mapping (uint => address) commentToUser;
    mapping (address => uint) userToCount;

    // 评论与项目关系
    mapping (uint => uint) commentToPragram;
    mapping (uint => uint) programToCount;
    
    function _createComment(uint8 _score, string _content) private returns (uint) {
        uint commentId = comments.push(Comment(_score, _content, 1)) - 1;
        commentToUser[commentId] = msg.sender;
        userToCount[msg.sender]++;
        return commentId;
    }

    function _createProgram(string _name) private {
        programs.push(Program(_name));
    }

    // 创建节目
    function createProgram(string _name) public onlyOwner {
        _createProgram(_name);
    }

    // 评论节目
    function comment(uint programId, uint8 _score, string _content) public {
        uint commentId = _createComment(_score, _content);
        commentToPragram[commentId] = programId;
        programToCount[programId]++;
    }

    function getProgramAverageScore(uint programId) public returns (uint) {
        uint fz = 0;
        uint fm = 0;
        for (uint i = 0; i < comments.length; i++) {
            if (commentToPragram[i] == programId) {
                fz += comments[i].score * comments[i].weight;
                fm += comments[i].weight;
            }
        }

        if (fm == 0) {
            return 0;
        } else {
            return fz / fm; // 保留1位小数
        }
    }
}