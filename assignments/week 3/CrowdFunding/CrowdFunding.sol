//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;


contract CrowdFunding {

    struct Project {
        address creator;
        uint totalNeeded;
        uint amountRaised;
        bool fundingCompleted;
        bool fundsWithdrawn;
    }

    Project[] public projects;
    
    mapping(uint => mapping(address => uint)) public contributions;


    function ProjectDetails(uint amount) public {
        require(amount > 0, "Amount should be greater than zero");
        Project memory project;
        project.creator = msg.sender;
        project.totalNeeded = amount;
        projects.push(project);
    }

    function ContributeTofund(uint projectId) public payable {
        require(projectId < projects.length - 1 , "project Id not exist");
        require(msg.value > 0, "Amount should be greater than zero");
        Project storage project = projects[projectId];
        require(!project.fundingCompleted, "Project has already been funded");
        project.amountRaised += msg.value;
        if(project.amountRaised >= project.totalNeeded) {
            project.fundingCompleted = true;
        }
        contributions[projectId][msg.sender] += msg.value;
    }

    function WithdrawContribution(uint projectId) public {
        require(projectId < projects.length - 1 , "project Id not exist");
        require(contributions[projectId][msg.sender] > 0, "Not enough funds to withdraw");

        Project storage project = projects[projectId];
        require(project.fundingCompleted, "Funding has been completed. Withdraw not possible");

        uint amount = contributions[projectId][msg.sender];
        contributions[projectId][msg.sender] = 0;
        project.amountRaised -= amount;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to withdraw Ether");
    }

    function withdrawFunds(uint projectId) public {
        require(projectId < projects.length -1, "project Id not exist");
        Project storage project = projects[projectId];

        if (!project.fundingCompleted) {
            revert("Withdraw not allowed");
        }

        if (project.fundsWithdrawn) {
            revert("Already withdrawn");
        }

        project.fundsWithdrawn = true;

        (bool sent, ) = project.creator.call{value: project.amountRaised}("");
        require(sent, "Failed to withdraw Ether");
    }



}