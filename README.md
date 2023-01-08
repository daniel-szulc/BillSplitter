<h1 align="center"> BillSplitter  </h1>
<h3 align="center">made by <a href="https://github.com/daniel-szulc">Szulc</a> and <a href="https://github.com/mati-wojtacha">Wojtasiński</a></h3>

<div align="center">

![Erlang](https://img.shields.io/badge/Erlang-A90432?logo=erlang&logoColor=white)
![Elixir](https://img.shields.io/badge/Elixir-4B275F?logo=elixir&logoColor=white)
![HTML](https://img.shields.io/badge/HTML5-E34F26?logo=html5&logoColor=white)
![CSS](https://img.shields.io/badge/CSS3-1572B6?logo=css3&logoColor=white)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
</div>

## About

Bill Splitter app was developed using the Erlang and Elixir languages and the Phoenix framework. The user can enter information about bills and assign them to specific persons, and then use the fee sharing algorithm so that the number of transactions is as small as possible.
Bill Splitter uses an algorithm that quickly calculates the initial split of the bill, but does not provide an optimal solution.

The process of using the Bill splitter application is as follows: the user enters information about the bill on the front-end page, including the name of the transaction, the amount and the persons to be split. Then, this data is transferred to the back-end, where it is read, recalculated and divided according to a predetermined algorithm. After calculating the results, the back-end sends them back to the front-end where they are displayed to the user.

Final project for completing the course at the University of Zielona Gora.

## Usage

### Start the Erlang server

Using the Erlang console, start the server using:

```erlang
1> splitter_server:start().
```

Erlang server files are located in the directory: `./server`

### Start the Phoenix server

```sh
$ mix phx.server
```

Phoenix app files are located in the directory: `./splitter`

## Screenshots

<img src="/screenshots/01.jpg" alt="BillSplitter"/>

<img src="/screenshots/02.jpg" alt="BillSplitter"/>

<img src="/screenshots/03.jpg" alt="BillSplitter"/>

