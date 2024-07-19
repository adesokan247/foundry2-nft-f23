// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {console} from "forge-std/console.sol";


contract MoodNft is ERC721 {
    // errors
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    enum Mood {
        SAD,
        HAPPY
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;
    event CreatedNft (uint256 indexed tokenId);

    constructor(string memory sadSvgImageUri, string memory happySvgImageUri) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    function mintNft() public {
        // uint256 tokenCounter = s_tokenCounter;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
        // emit CreatedNft(tokenCounter);


        // _safeMint(msg.sender, s_tokenCounter);
        // s_tokenCounter++;
        // emit CreatedNft(s_tokenCounter);
    }

    function flipMood(uint256 tokenId) public {
        // only want the NFT owner to be able to change the mood
        if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender){
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY){
            s_tokenIdToMood[tokenId] == Mood.SAD; // 0 sad 1 happy
            console.log("this is a sad mood");
        }else{
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
                        console.log("this is a sad mood");

        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;

        // console.log(s_tokenIdToMood[0]);
        // 0 sad 1 happy
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
                        console.log("this is an happy2 mood");

        } else {
            imageURI = s_sadSvgImageUri;
                        console.log("this is an sad2 mood");

        }
        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "An NFT that reflects the owners mood.", "attributes"[{"trait_type": "moodiness", "value": 100}], "image: "',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        ); // {"name": "Mood NFT"}
    }
}
