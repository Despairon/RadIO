#include "stm32f4xx_hal.h"
#include <stdbool.h>

/*class DuoBlinker
{
public:
    explicit DuoBlinker(GPIO_TypeDef *gpioPort, const uint16_t &pin1, const uint16_t &pin2, const uint32_t &delay);
    ~DuoBlinker(); 
    void go();
private:
    GPIO_TypeDef *gpioPort;
    uint16_t pin1;
    uint16_t pin2;
    uint32_t delay;

    void gpioPinInit(const uint16_t &pin) const;
};

DuoBlinker::DuoBlinker(GPIO_TypeDef *gpioPort, const uint16_t &pin1, const uint16_t &pin2, const uint32_t &delay):
    gpioPort(gpioPort),
    pin1(pin1),
    pin2(pin2),
    delay(delay)
{
    HAL_Init();

    if (gpioPort == GPIOA)
        __HAL_RCC_GPIOA_CLK_ENABLE();
    else if (gpioPort == GPIOB)
        __HAL_RCC_GPIOB_CLK_ENABLE();
    else if (gpioPort == GPIOC)
        __HAL_RCC_GPIOC_CLK_ENABLE();
    else
        return;

    gpioPinInit(pin1);
    gpioPinInit(pin2);
}

DuoBlinker::~DuoBlinker()
{
}

void DuoBlinker::gpioPinInit(const uint16_t &pin) const
{
    GPIO_InitTypeDef gpioInitStruct =
    {
        .Pin   = pin,
        .Mode  = GPIO_MODE_OUTPUT_PP,
        .Pull  = GPIO_PULLUP,
        .Speed = GPIO_SPEED_FREQ_HIGH
    };

    HAL_GPIO_Init(this->gpioPort, &gpioInitStruct);  
}

void DuoBlinker::go()
{
    bool first_cycle = true;
    while (true)
    {
        HAL_GPIO_TogglePin(this->gpioPort, this->pin1);

        if (!first_cycle)
            HAL_GPIO_TogglePin(this->gpioPort, this->pin2);

        first_cycle = false;

        HAL_Delay(this->delay);
    }
}*/

int main()
{
    //DuoBlinker duoBlinker(GPIOB, GPIO_PIN_0, GPIO_PIN_1, 500);

    //duoBlinker.go();

    HAL_Init();

    __HAL_RCC_GPIOB_CLK_ENABLE();

    GPIO_InitTypeDef gpio_init_struct =
    {
        .Pin   = GPIO_PIN_0,
        .Mode  = GPIO_MODE_OUTPUT_PP,
        .Pull  = GPIO_PULLUP,
        .Speed = GPIO_SPEED_FREQ_HIGH
    };

    HAL_GPIO_Init(GPIOB, &gpio_init_struct);

    gpio_init_struct.Pin = GPIO_PIN_1;

    HAL_GPIO_Init(GPIOB, &gpio_init_struct);

    bool first_cycle = true;
    while (true)
    {
        HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_0);

        if (!first_cycle)
            HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_1);

        first_cycle = false;

        HAL_Delay(500);
    }
}

void SysTick_Handler(void)
{
  HAL_IncTick();
}

void NMI_Handler(void)
{
}

void HardFault_Handler(void)
{
  while (1) {}
}


void MemManage_Handler(void)
{
  while (1) {}
}

void BusFault_Handler(void)
{
  while (1) {}
}

void UsageFault_Handler(void)
{
  while (1) {}
}

void SVC_Handler(void)
{
}

void DebugMon_Handler(void)
{
}

void PendSV_Handler(void)
{
}