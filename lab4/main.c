#include "stdint.h"


// Визначення регістрів через прямий доступ до пам'яті
#define RCC_AHB1ENR   (*((volatile uint32_t*)0x40023830))
#define GPIOA_MODER   (*((volatile uint32_t*)0x40020000))
#define GPIOA_IDR     (*((volatile uint32_t*)0x40020010))
#define GPIOD_MODER   (*((volatile uint32_t*)0x40020C00))
#define GPIOD_ODR     (*((volatile uint32_t*)0x40020C14))
// Функція затримки
void delay(volatile uint32_t n) {
    while(n--);
}

void blink_all(uint32_t t) {
    GPIOD_ODR |= (0xF << 12);
    delay(t);
    GPIOD_ODR &= ~(0xF << 12);
    delay(t);
}

int main(void) {
    // Тактування GPIOA і GPIOD
    RCC_AHB1ENR |= (1 << 0) | (1 << 3);

    // PA0 — вхід (кнопка USER)
    GPIOA_MODER &= ~(3 << 0);

    // PD12-PD15 — вихід
    GPIOD_MODER &= ~(0xFF << 24);
    GPIOD_MODER |=  (0x55 << 24);

    while(1) {
        // Чекаємо натискання кнопки PA0
        if (GPIOA_IDR & (1 << 0)) {
            // Кнопку натиснуто блимаємо
            blink_all(500000);
        }
    }
}
