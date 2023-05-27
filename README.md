# Apple Watch Motion Data Fetching App

## Overview

This application is designed to fetch and visualize the motion data from an Apple Watch. It allows you to fetch and display the following data:
![6DCBEFD9-BA0A-49A6-8591-C36E3C8774BC_1_102_o](https://github.com/akihikooharazawa/get_motionData/assets/26277799/a40ee584-2a52-40d3-b107-86741f4f57c7)
![2A168200-4A95-40A5-82A5-0C27784E4CC1](https://github.com/akihikooharazawa/get_motionData/assets/26277799/3471677a-703e-4cfe-8788-cc180ead0c1c)

- Attitude (Roll, Pitch, Yaw)
- Gravity (X, Y, Z)
- Rotation Rate (X, Y, Z)
- User Acceleration (X, Y, Z)

## Installation

### Requirements

- iOS 14.0 or later
- watchOS 7.0 or later
- Xcode 12 or later
- Swift 5.3 or later

### Steps

1. Clone or download this repository:git clone https://github.com/akihikooharazawa/get_motionData.git
2. Open Xcode and navigate to the downloaded project file.
3. Select "Product > Run" or press the Cmd+R keys to run the application.

## Usage

Put on your Apple Watch and move in the situation where you want to fetch the motion data. Then, open the application and you can check the fetched data in graph form.

## Limitation
Data acquired by the applewatch is displayed graphically on the iphone in real time, but when the refresh rate is automatically changed to 1hz by turning the wrist, the iphone stops updating the graph. This is due to WatchConnectivity specifications, and Apple has not provided a solution at this time.

## Contributing

Contributions to this project are welcome! If you find something you'd like to improve, please feel free to create an issue or send a Pull Request.

## License

This project is published under the MIT License. For more details, please check the [LICENSE](LICENSE) file.

