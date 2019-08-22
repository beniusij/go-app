package poker

import (
	"bufio"
	"fmt"
	"io"
	"strconv"
	"strings"
)

type Game interface {
	Start(numberOfPlayers int, alertsDestination io.Writer)
	Finish(winner string)
}

type CLI struct {
	playerStore PlayerStore
	in 			*bufio.Scanner
	out			io.Writer
	game		Game
}

const PlayerPrompt = "Please enter the number of players: "
const BadPlayerInputErrMsg = "Bad value received for number of players, please try again with a number"

func NewCLI(in io.Reader, out io.Writer, game Game) *CLI  {
	return &CLI{
		in:		bufio.NewScanner(in),
		out:	out,
		game:	game,
	}

}

func (cli *CLI) PlayPoker() {
	fmt.Fprint(cli.out, PlayerPrompt)

	numberOfPlayers, err := strconv.Atoi(cli.readLine())

	if err != nil {
		fmt.Fprintf(cli.out, BadPlayerInputErrMsg)
		return
	}

	cli.game.Start(numberOfPlayers, cli.out)

	winnerInput := cli.readLine()
	winner := extractWinner(winnerInput)

	cli.game.Finish(winner)
}

func extractWinner(userInput string) string {
	return strings.Replace(userInput, " wins", "", 1)
}

func (cli *CLI) readLine() string {
	cli.in.Scan()
	return cli.in.Text()
}