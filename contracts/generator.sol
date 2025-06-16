// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Generator {
    string[] public hat_colors = [
        "#f4a261", "#e76f51", "#264653", "#2a9d8f", "#e9c46a", 
        "#8d99ae", "#d62828", "#f77f00", "#fcbf49", "#003049", 
        "#d4a373", "#ffb4a2", "#cb997e", "#a5a58d", "#6b705c", 
        "#ffe8d6", "#f28482", "#84a59d", "#f5cac3", "#f28482", 
        "#0d3b66", "#faf0ca", "#f4d35e", "#ee964b", "#f95738", 
        "#fb8500", "#023047", "#219ebc", "#8ecae6", "#ffb703", 
        "#adb5bd"
    ];
    
    string[] public face_colors = [
        "#ffddd2", "#ffe8d6", "#fcbf49", "#e63946", "#f1faee", 
        "#a8dadc", "#457b9d", "#1d3557", "#ffcdb2", "#ffb4a2", 
        "#e5989b", "#b5838d", "#6d6875", "#ffcc99", "#fddbb5", 
        "#f0c6a1", "#edc9af", "#d2b48c", "#deb887", "#ffe4c4", 
        "#faebd7", "#f4a460", "#d2691e", "#cd853f", "#f5deb3", 
        "#f8e4d9", "#ffe4b5", "#ffb6c1", "#f0e68c", "#ff6347", 
        "#ff4500"
    ];
    
    string[] public eye_colors = [
        "#3d405b", "#81b29a", "#f2cc8f", "#e07a5f", "#6a994e", 
        "#22223b", "#4a4e69", "#9a8c98", "#c9ada7", "#f2e9e4", 
        "#2d6a4f", "#40916c", "#52b788", "#74c69d", "#95d5b2", 
        "#2f3e46", "#4c566a", "#434c5e", "#8fbcbb", "#88c0d0", 
        "#81a1c1", "#5e81ac", "#bf616a", "#d08770", "#ebcb8b", 
        "#a3be8c", "#b48ead", "#3b4252", "#5e81ac", "#8fa1b3", 
        "#89b4c6"
    ];
    
    string[] public mouth_colors = [
        "#ef476f", "#ffd166", "#06d6a0", "#118ab2", "#073b4c", 
        "#f07167", "#f4a261", "#2a9d8f", "#d62828", "#f77f00", 
        "#118ab2", "#06d6a0", "#ffca3a", "#2ec4b6", "#f72585", 
        "#4361ee", "#4cc9f0", "#3a86ff", "#8338ec", "#ff006e", 
        "#fb5607", "#ffbe0b", "#ff7b00", "#ff0054", "#fe7f2d", 
        "#ef476f", "#8338ec", "#9d4edd", "#e36414", "#f08080", 
        "#ffcc00"
    ];
    
    string[] public nose_colors = [
        "#e09f3e", "#9c6644", "#cb997e", "#b5838d", "#6b705c", 
        "#ffddd2", "#f4a261", "#2a9d8f", "#e9c46a", "#003049", 
        "#d4a373", "#ffb4a2", "#d62828", "#f77f00", "#fcbf49", 
        "#8d99ae", "#264653", "#fb8500", "#219ebc", "#8ecae6", 
        "#84a98c", "#4a4e69", "#a8dadc", "#457b9d", "#e63946", 
        "#f1faee", "#f07167", "#f4a261", "#2a9d8f", "#d62828", 
        "#003049"
    ];
    
    string[] public background_colors = [
        "#f0efeb", "#e07a5f", "#3d405b", "#81b29a", "#f2cc8f", 
        "#ffddd2", "#ffe8d6", "#edf6f9", "#e9c46a", "#f4a261", 
        "#264653", "#2a9d8f", "#8d99ae", "#d62828", "#fcbf49", 
        "#f07167", "#3d5a80", "#293241", "#ee6c4d", "#98c1d9", 
        "#2b2d42", "#8d99ae", "#d4a373", "#cdb4db", "#ffb4a2", 
        "#6b705c", "#ffd166", "#06d6a0", "#118ab2", "#073b4c", 
        "#fca311"
    ];
    
    // Crown/hat special colors for royal effect
    string[] public crown_colors = [
        "#9B59B6", "#8E44AD", "#663399", "#4B0082", "#6A0DAD",
        "#7B68EE", "#6A5ACD", "#483D8B", "#4169E1", "#0000CD",
        "#191970", "#000080", "#00008B", "#1E90FF", "#4682B4"
    ];
    
    // Function to get a random color from an array
    function randomColor(uint256 tokenId, string[] memory colorArray, string memory trait) internal pure returns (string memory) {
        uint256 rand = uint256(keccak256(
            abi.encodePacked(tokenId, trait)
        )) % colorArray.length;

        return colorArray[rand];
    }

    
    // Helper to determine if we should show sparkles (20% chance)
    function shouldShowSparkles(uint256 tokenId) internal view returns (bool) {
        uint256 rand = uint256(keccak256(abi.encodePacked("sparkles", tokenId, block.timestamp))) % 100;
        return rand < 20;
    }
    
    // Get gradient background
    function getGradientBackground(uint256 tokenId) internal view returns (string memory) {
        string memory color1 = randomColor(tokenId, background_colors, "bg1");
        string memory color2 = randomColor(tokenId, background_colors, "bg2");
        
        return string(abi.encodePacked(
            "linear-gradient(135deg, ", color1, " 0%, ", color2, " 100%)"
        ));
    }
    
    function getPunkSVG(uint256 tokenId) public view returns (string memory) {
        string memory faceColor = randomColor(tokenId, face_colors, "face");
        string memory eyeColor = randomColor(tokenId, eye_colors, "eyes");
        string memory noseColor = randomColor(tokenId, nose_colors, "nose");
        string memory mouthColor = randomColor(tokenId, mouth_colors, "mouth");
        string memory crownColor = randomColor(tokenId, crown_colors, "crown");
        
        return string(
            abi.encodePacked(
                getSVGHeader(tokenId),
                getSVGBody(faceColor, eyeColor, noseColor, mouthColor, crownColor, tokenId),
                getSVGFooter()
            )
        );
    }
    
    function getSVGHeader(uint256 tokenId) internal view returns (string memory) {
        return string(abi.encodePacked(
            "<svg xmlns='http://www.w3.org/2000/svg' style='background:", 
            getGradientBackground(tokenId),
            "' version='1.0' width='386.000000pt' height='383.000000pt' viewBox='0 0 386.000000 383.000000'>",
            "<defs>",
                "<filter id='glow' x='-20%' y='-20%' width='140%' height='140%'>",
                    "<feGaussianBlur stdDeviation='3' result='coloredBlur'/>",
                    "<feMerge>",
                        "<feMergeNode in='coloredBlur'/>",
                        "<feMergeNode in='SourceGraphic'/>",
                    "</feMerge>",
                "</filter>",
                "<filter id='dropshadow' x='-30%' y='-30%' width='160%' height='160%'>",
                    "<feDropShadow dx='2' dy='4' stdDeviation='3' flood-color='#1a1a1a' flood-opacity='0.4'/>",
                "</filter>",
            "</defs>",
            "<g transform='translate(0.000000,383.000000) scale(0.100000,-0.100000)' stroke='none'>"
        ));
    }
    
    function getSVGBody(
        string memory faceColor,
        string memory eyeColor,
        string memory noseColor,
        string memory mouthColor,
        string memory crownColor,
        uint256 tokenId
    ) internal view returns (string memory) {
        return string(abi.encodePacked(
            // Main body with drop shadow
            "<path fill='", faceColor, "' filter='url(#dropshadow)' d='M1280 3120 l0 -80 -80 0 -80 0 0 -80 0 -80 -80 0 -80 0 0 -400 0 -400 -80 0 -80 0 0 -80 0 -80 -80 0 -80 0 0 -80 0 -80 80 0 80 0 0 -160 0 -160 80 0 80 0 0 -720 0 -720 80 0 80 0 0 800 0 800 -80 0 -80 0 0 80 0 80 80 0 80 0 0 320 0 320 720 0 720 0 0 -160 0 -160 -160 0 -160 0 0 -160 0 -160 160 0 160 0 0 -560 0 -560 -80 0 -80 0 0 -80 0 -80 -400 0 -400 0 0 -240 0 -240 80 0 80 0 0 160 0 160 320 0 320 0 0 80 0 80 80 0 80 0 0 80 0 80 80 0 80 0 0 880 0 880 240'/>",
            
            // Eyes with glow
            "<path fill='", eyeColor, "' filter='url(#glow)' d='M1440 1920 l0 -160 160 0 160 0 0 160 0 160 -160 0 -160 0 0 -160z'/>",
            "<path fill='", eyeColor, "' filter='url(#glow)' d='M2000 1920 l0 -160 160 0 160 0 0 160 0 160 -160 0 -160 0 0 -160z'/>",
            
            // Eye pupils with animation
            "<g>",
                "<path fill='#1a1a1a' d='M1480 1920 l0 -80 80 0 80 0 0 80 0 80 -80 0 -80 0 0 -80z'/>",
                "<path fill='#1a1a1a' d='M2040 1920 l0 -80 80 0 80 0 0 80 0 80 -80 0 -80 0 0 -80z'/>",
                "<animateTransform attributeName='transform' attributeType='XML' type='translate' values='0,0; 2,0; 0,0; -2,0; 0,0' dur='4s' repeatCount='indefinite'/>",
            "</g>",
            
            // Eye highlights
            "<path fill='white' opacity='0.7' d='M1460 1880 l0 -40 40 0 40 0 0 40 0 40 -40 0 -40 0 0 -40z'/>",
            "<path fill='white' opacity='0.7' d='M2020 1880 l0 -40 40 0 40 0 0 40 0 40 -40 0 -40 0 0 -40z'/>",
            
            // Nose with shadow
            "<path fill='", noseColor, "' filter='url(#dropshadow)' d='M1820 1360 l0 -240 80 0 80 0 0 240 0 240 -80 0 -80 0 0 -240z'/>",
            
            // Mouth
            "<path fill='", mouthColor, "' filter='url(#dropshadow)' d='M1500 880 h60 a60,60 0 0 1 60,-60 h620 a60,60 0 0 1 60,60 v40 a60,60 0 0 1 -60,60 h-620 a60,60 0 0 1 -60,-60 v-40 h-60 z'/>",
            
            // Crown with glow
            "<path fill='", crownColor, "' filter='url(#glow)' d='M960 2480 l0 -80 1050 0 790 0 0 340 0 80 -80 0 -80 0 0 190 0 190 -1050 0 -470 0 0 -80 0 -80 -80 0 -80 0 0 -80z'/>",
            
            // Crown gems
            "<path fill='#E74C3C' d='M1200 2520 l0 -40 40 0 40 0 0 40 0 40 -40 0 -40 0 0 -40z'/>",
            "<path fill='#27AE60' d='M1400 2520 l0 -40 40 0 40 0 0 40 0 40 -40 0 -40 0 0 -40z'/>",
            "<path fill='#E74C3C' d='M1600 2520 l0 -40 40 0 40 0 0 40 0 40 -40 0 -40 0 0 -40z'/>",
            
            // Sparkles (conditional)
            shouldShowSparkles(tokenId) ? getSparkles() : "",
            
            // Floating animation
            "<animateTransform attributeName='transform' attributeType='XML' type='translate' values='0,383 0,-383; 0,378 0,-383; 0,383 0,-383' dur='3s' repeatCount='indefinite'/>"
        ));
    }
    
    function getSparkles() internal pure returns (string memory) {
        return string(abi.encodePacked(
            "<g opacity='0.8'>",
                "<path fill='#F1C40F' d='M800 2800 l0 -20 10 0 10 0 10 -10 10 -10 0 10 0 10 10 0 10 0 0 20 0 20 -10 0 -10 0 -10 10 -10 10 0 -10 0 -10 -10 0 -10 0 0 -20z'/>",
                "<path fill='#F1C40F' d='M2800 2400 l0 -20 10 0 10 0 10 -10 10 -10 0 10 0 10 10 0 10 0 0 20 0 20 -10 0 -10 0 -10 10 -10 10 0 -10 0 -10 -10 0 -10 0 0 -20z'/>",
                "<path fill='#F1C40F' d='M600 1800 l0 -15 8 0 8 0 8 -8 8 -8 0 8 0 8 8 0 8 0 0 15 0 15 -8 0 -8 0 -8 8 -8 8 0 -8 0 -8 -8 0 -8 0 0 -15z'/>",
                "<animateTransform attributeName='transform' attributeType='XML' type='rotate' values='0 0 0; 360 0 0' dur='10s' repeatCount='indefinite'/>",
            "</g>"
        ));
    }
    
    function getSVGFooter() internal pure returns (string memory) {
        return "</g></svg>";
    }
}
