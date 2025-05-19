let selectedChessFigure = null; // Выбранная фигура
let currentPlayer = 'white'; // Текущий игрок

document.getElementById('startButton').addEventListener('click', () => {
    startChessGame();
});

document.getElementById('colorThemeSelected').addEventListener('change', () => {
    setColorTheme();
});

document.getElementById('restartButton').addEventListener('click', restartParty);

function showGameStatus(status) {
    const modal = document.getElementById('modal');
    const modalMessage = document.getElementById('modal-message');

    if (status === "мат") {
        modalMessage.textContent = "Игра окончена! Мат!";
        const chessBoard = document.getElementById('chessBoard');
        chessBoard.classList.add('blocked');
    } else if (status === "шах") {
        modalMessage.textContent = "Шах!";
    } else if (status === "пат") {
        modalMessage.textContent = "Игра окончена! Пат!";
        const chessBoard = document.getElementById('chessBoard');
        chessBoard.classList.add('blocked');
    } else if (status === "продолжение") {
        return;
    }

    modal.style.display = "block";

    const squares = document.querySelectorAll('.square');

    // Закрытие модального окна при нажатии на кнопку закрытия
    const closeButton = document.querySelector('.close-button');
    closeButton.onclick = function () {
        modal.style.display = "none";
    }

    // Закрытие модального окна при клике вне его
    window.onclick = function (event) {
        if (event.target === modal) {
            modal.style.display = "none";
        }
    }
}


function restartParty() {
    startChessGame();
    const chessBoard = document.getElementById('chessBoard');
    chessBoard.classList.remove('blocked');
}



// Установка цветовой темы шахматной доски
function setColorTheme() {
    const theme = document.getElementById('colorThemeSelected').value;
    const squares = document.querySelectorAll('.square');

    squares.forEach((square, index) => {
        if (theme === 'grayWhiteTheme')
            square.className = (Math.floor(index / 8) + index % 8) % 2 === 0 ? 'white square' : 'gray square';
        else if (theme === 'brownBeigeTheme')
            square.className = (Math.floor(index / 8) + index % 8) % 2 === 0 ? 'beige square' : 'brown square';
        else if (theme === 'yellowGreenTheme')
            square.className = (Math.floor(index / 8) + index % 8) % 2 === 0 ? 'yellow square' : 'green square';
        else if (theme === 'whitePurpleTheme')
            square.className = (Math.floor(index / 8) + index % 8) % 2 === 0 ? 'white square' : 'purple square';
    });
}

// Запуск шахматной партии
function startChessGame() {
    fetch(`http://127.0.0.1:3000/start`, {
        method: "POST", // обычно для перезапуска используют POST
        headers: {
            "Content-Type": "application/json",
        },
    }).then((response) => {
        if (!response.ok)
            throw new Error("Сетевая ошибка: " + response.status);
        return response.json();
    }).then((data) => {
        // Скрытие компонентов
        document.getElementById('startButton').style.display = 'none';
        document.getElementById('restartButton').style.display = 'none';

        // Появление компонентов
        document.getElementById('currentPlayerDisplay').style.display = 'block';
        document.getElementById('colorThemes').style.display = 'inline';
        document.getElementById('resignButton').style.display = 'inline-block';

        spawnChessBoard();
        spawnChessFigures();
        updateCurrentPlayerDisplay();
        document.getElementById('resignButton').addEventListener('click', () => { handleResign(); });

        currentPlayer = 'white';

        console.log("Game is started");
    }).catch((error) => {
        console.error("Ошибка при перезапуске уровня:", error);
        alert("Произошла ошибка при перезапуске уровня");
    });
}

// Функция окончания игры (поднятия белого флага)
function handleResign() {
    alert(`Игрок ${currentPlayer === 'white' ? 'Белый' : 'Чёрный'} сдался!`);

    // Скрытие компонентов
    document.getElementById('chessBoard').style.display = 'none';
    document.getElementById('currentPlayerDisplay').style.display = 'none';
    document.getElementById('resignButton').style.display = 'none';
    document.getElementById('colorThemes').style.display = 'none';

    // Отображение компонентов
    document.getElementById('restartButton').style.display = 'inline-block';
}

// Обновление дисплея текущего игрока
function updateCurrentPlayerDisplay() {
    document.getElementById('currentPlayerColor').textContent = currentPlayer === 'white' ? 'Белый' : 'Чёрный';
}

// Создание шахматной доски
function spawnChessBoard() {
    const board = document.getElementById('chessBoard');
    board.style.display = 'grid';
    board.innerHTML = '';

    for (let i = 0; i < 8; ++i) {
        for (let j = 0; j < 8; ++j) {
            const square = document.createElement('div');
            square.className = (i + j) % 2 === 0 ? 'white square' : 'gray square';
            square.dataset.position = `${i}-${j}`;
            board.appendChild(square);
        }
    }

}

// Появление шахматных фигур
function spawnChessFigures() {
    const figures = {

        // Белые фигуры
        '7-0': { symbol: '♖', color: 'white' }, '7-1': { symbol: '♘', color: 'white' },
        '7-2': { symbol: '♗', color: 'white' }, '7-3': { symbol: '♕', color: 'white' },
        '7-4': { symbol: '♔', color: 'white' }, '7-5': { symbol: '♗', color: 'white' },
        '7-6': { symbol: '♘', color: 'white' }, '7-7': { symbol: '♖', color: 'white' },

        // Черные фигуры
        '0-0': { symbol: '♜', color: 'black' }, '0-1': { symbol: '♞', color: 'black' },
        '0-2': { symbol: '♝', color: 'black' }, '0-3': { symbol: '♛', color: 'black' },
        '0-4': { symbol: '♚', color: 'black' }, '0-5': { symbol: '♝', color: 'black' },
        '0-6': { symbol: '♞', color: 'black' }, '0-7': { symbol: '♜', color: 'black' },

        // Белые пешки (второй ряд)
        '6-0': { symbol: '♙', color: "white" },
        '6-1': { symbol: '♙', color: "white" },
        '6-2': { symbol: '♙', color: "white" },
        '6-3': { symbol: '♙', color: "white" },
        '6-4': { symbol: '♙', color: "white" },
        '6-5': { symbol: '♙', color: "white" },
        '6-6': { symbol: '♙', color: "white" },
        '6-7': { symbol: '♙', color: "white" },

        // Черные пешки (седьмой ряд)
        '1-0': { symbol: '♟', color: 'black' },
        '1-1': { symbol: '♟', color: 'black' },
        '1-2': { symbol: '♟', color: 'black' },
        '1-3': { symbol: '♟', color: 'black' },
        '1-4': { symbol: '♟', color: 'black' },
        '1-5': { symbol: '♟', color: 'black' },
        '1-6': { symbol: '♟', color: 'black' },
        '1-7': { symbol: '♟', color: 'black' }
    };

    const squares = document.querySelectorAll('.square');
    squares.forEach(square => {
        const position = square.dataset.position;

        if (figures[position]) {
            square.textContent = figures[position].symbol;
            square.dataset.color = figures[position].color;

            square.addEventListener('click', handleSelectChessFidure);
        }
        else square.dataset.color = "nil";
    });
}

function UnLightCells() {
    const squares = document.querySelectorAll('.square');
    squares.forEach(square => {
        square.classList.remove('allowed');
        square.classList.remove('selected');

        const handleMoveClick = square.originalHandleClick;
        if (handleMoveClick != null) {
            square.removeEventListener('click', handleMoveClick);
            delete square.originalHandleClick;
        }
        if (square.textContent !== '')
            square.addEventListener('click', handleSelectChessFidure);
    });
}

function SelectChessFigure(position) {
    if (selectedChessFigure != null) {
        UnLightCells();
        selectedChessFigure = null;
        return;
    }

    const selectedSquare = document.querySelector(`.square[data-position="${position}"]`);
    const figureColor = selectedSquare.dataset.color;
    if ((currentPlayer === "white" && figureColor !== "white") || (currentPlayer === "black" && figureColor !== "black")) {
        alert("Выберите фигуру вашего цвета!");
        return;
    }

    selectedSquare.classList.add('selected');
    selectedChessFigure = position;

    fetch(`http://127.0.0.1:3000/moves?position=${position}`, {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
        },
    }).then(response => {
        if (!response.ok)
            throw new Error("Network Error: " + response.status);
        return response.json();
    }).then(moves => {
        console.log("Succes: ", moves);
        LightCell(moves);
    }).catch((error) => {
        console.error("Error: ", error);
        alert("Произошла ошибка при получении допустимых ходов");
    });
}

function LightCell(moves) {
    moves.forEach(position => {
        const square = document.querySelector(`.square[data-position="${position}"]`);
        if (square != null) {
            square.classList.add('allowed');

            const handleMoveClick = () => {
                moveChessFigure(selectedChessFigure, position);
                UnLightCells();
                selectedChessFigure = null;
            };

            square.removeEventListener('click', handleSelectChessFidure);
            square.addEventListener('click', handleMoveClick);
            square.originalHandleClick = handleMoveClick;
        }
    });
}

function moveChessFigure(from, to) {
    const fromSquare = document.querySelector(`.square[data-position="${from}"]`);
    const toSquare = document.querySelector(`.square[data-position="${to}"]`);

    if (!fromSquare || !toSquare) return;

    const figure = fromSquare.textContent;

    if (toSquare.textContent && (figure === toSquare.textContent)) return;

    fetch('http://127.0.0.1:3000/move', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            from: from,
            to: to,
        }),
    }).then(response => {
        if (!response.ok)
            throw new Error('Network error: ' + response.status);
        return response.json();
    }).then(data => {
        moveMultipleFigures(data.old_coordinates, data.new_coordinates);
        showGameStatus(data.status);
    }).catch(error => {
        console.error('Error:', error);
        alert('Произошла ошибка при перемещении фигуры');
    });
}

function moveMultipleFigures(old_coords_array, new_coords_array) {
    for (let i = 0; i < old_coords_array.length; ++i) {

        const oldCoord = old_coords_array[i];
        const newCoord = new_coords_array[i];

        const oldPosition = `${oldCoord[0]}-${oldCoord[1]}`;
        const fromSquare = document.querySelector(`.square[data-position="${oldPosition}"]`);
        if (!fromSquare || fromSquare.textContent.trim() === '') continue;


        if (newCoord[0] === null && newCoord[1] === null) {
            fromSquare.textContent = '';
            fromSquare.dataset.color = "nil";
            continue;
        }

        const newPosition = `${newCoord[0]}-${newCoord[1]}`;
        const toSquare = document.querySelector(`.square[data-position="${newPosition}"]`);
        if (!toSquare) continue;

        const figure = fromSquare.textContent;

        const rectFrom = fromSquare.getBoundingClientRect();
        const rectTo = toSquare.getBoundingClientRect();

        const temp = document.createElement('div');
        document.body.appendChild(temp);
        temp.textContent = figure;
        temp.className = 'chess-figure';

        temp.style.position = 'absolute';
        temp.style.left = `${rectFrom.left}px`;
        temp.style.top = `${rectFrom.top}px`;

        fromSquare.textContent = '';

        setTimeout(() => {
            temp.style.transition = 'transform 0.5s ease';
            temp.style.transform = `translate(${rectTo.left - rectFrom.left}px, ${rectTo.top - rectFrom.top}px)`;
        }, 10);

        setTimeout(() => {
            if (newPosition[0] === "0" && temp.textContent === "♙") {
                toSquare.textContent = "♕";
            } else if (newPosition[0] === "7" && temp.textContent === "♟") {
                toSquare.textContent = "♛";
            } else {
                toSquare.textContent = figure;
            }

            document.body.removeChild(temp);

            toSquare.dataset.color = fromSquare.dataset.color;
            fromSquare.dataset.color = "nil";

            fromSquare.removeEventListener('click', handleSelectChessFidure);
            toSquare.addEventListener('click', handleSelectChessFidure);
        }, 510);
    }

    currentPlayer = currentPlayer === 'white' ? 'black' : 'white';
    updateCurrentPlayerDisplay();

    UnLightCells();
}

// Функция выбора шахматной фигуры
function handleSelectChessFidure(event) {
    SelectChessFigure(event.currentTarget.dataset.position);
}