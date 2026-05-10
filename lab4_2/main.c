#include "stdint.h"

#define RCC_AHB1ENR   (*((volatile uint32_t*)0x40023830))
#define GPIOA_MODER   (*((volatile uint32_t*)0x40020000))
#define GPIOA_IDR     (*((volatile uint32_t*)0x40020010))
#define GPIOD_MODER   (*((volatile uint32_t*)0x40020C00))
#define GPIOD_ODR     (*((volatile uint32_t*)0x40020C14))

// PD15(синій) -> PD14(червоний) -> PD13(помаранчевий) -> PD12(зелений)
uint8_t led_order[] = {15, 14, 13, 12};

void delay(volatile uint32_t n) {
    while(n--);
}

void run_sequence(void) {
    for (int i = 0; i < 4; i++) {
        GPIOD_ODR &= ~(0xF << 12); // вимкнути всі
        GPIOD_ODR |= (1 << led_order[i]); // увімкнути поточний
        delay(500000000); // ~2 секунди
    }
    GPIOD_ODR &= ~(0xF << 12); // вимкнути всі після циклу
}

int main(void) {
    RCC_AHB1ENR |= (1 << 0) | (1 << 3);

    GPIOA_MODER &= ~(3 << 0);      // PA0 — вхід
    GPIOD_MODER &= ~(0xFF << 24);  // PD12-PD15 — вихід
    GPIOD_MODER |=  (0x55 << 24);
    GPIOD_ODR &= ~(0xF << 12);     // всі вимкнені

    uint8_t btn_prev = 0;

    while(1) {
        uint8_t btn = (GPIOA_IDR & (1 << 0)) ? 1 : 0;

        if (btn && !btn_prev) {
            run_sequence(); // один цикл на одне натискання
        }

        btn_prev = btn;
        delay(50000);
    }
}
