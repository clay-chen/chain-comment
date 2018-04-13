var CommentFactory = artifacts.require("CommentFactory");

module.exports = function (deployer) {
    deployer.deploy(CommentFactory);
};