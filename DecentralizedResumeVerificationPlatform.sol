// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract ResumeVerification {
    struct Resume {
        uint256 id;
        string name;
        string workHistory;
        address owner;
        bool verified;
    }

    uint256 private nextResumeId;
    mapping(uint256 => Resume) public resumes;
    mapping(address => uint256[]) private userResumes;

    event ResumeSubmitted(uint256 indexed id, string name, address indexed owner);
    event ResumeVerified(uint256 indexed id, address indexed verifier);

    function submitResume(string memory _name, string memory _workHistory) public {
        uint256 resumeId = nextResumeId++;
        resumes[resumeId] = Resume(resumeId, _name, _workHistory, msg.sender, false);
        userResumes[msg.sender].push(resumeId);
        emit ResumeSubmitted(resumeId, _name, msg.sender);
    }

    function verifyResume(uint256 _id) public {
        require(resumes[_id].owner != address(0), "Resume does not exist");
        require(!resumes[_id].verified, "Already verified");

        resumes[_id].verified = true;
        emit ResumeVerified(_id, msg.sender);
    }

    function getResume(uint256 _id) public view returns (Resume memory) {
        return resumes[_id];
    }
}
