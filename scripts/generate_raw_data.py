from __future__ import annotations

import csv
import random
from datetime import date, timedelta
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SEEDS_DIR = ROOT / "seeds"
RANDOM_SEED = 42

CUSTOMER_COUNT = 1_200
PRODUCT_COUNT = 120
ORDER_COUNT = 12_000

FIRST_NAMES = [
    "Ana",
    "Bruno",
    "Carla",
    "Diego",
    "Elisa",
    "Fernanda",
    "Gabriel",
    "Helena",
    "Igor",
    "Julia",
    "Lucas",
    "Marina",
    "Nicolas",
    "Olivia",
    "Pedro",
    "Rafaela",
    "Thiago",
    "Vanessa",
    "William",
    "Yasmin",
]

LAST_NAMES = [
    "Silva",
    "Costa",
    "Martins",
    "Souza",
    "Pereira",
    "Lima",
    "Oliveira",
    "Santos",
    "Almeida",
    "Rocha",
    "Gomes",
    "Barbosa",
    "Ribeiro",
    "Mendes",
    "Carvalho",
]

COUNTRIES = ["BR", "BR", "BR", "BR", "AR", "CL", "UY"]
PAYMENT_METHODS = ["credit_card", "pix", "boleto", "debit_card"]
STATUS_WEIGHTS = [("completed", 0.86), ("cancelled", 0.08), ("returned", 0.06)]

CATEGORY_CATALOG = {
    "Eletronicos": [
        ("Notebook Pro", 4_800, 8_900),
        ("Monitor 27", 1_100, 2_800),
        ("Mouse Sem Fio", 80, 260),
        ("Headset USB", 180, 640),
        ("Teclado Mecanico", 240, 920),
    ],
    "Moveis": [
        ("Cadeira Ergonomica", 720, 2_400),
        ("Mesa Ajustavel", 1_200, 3_600),
        ("Gaveteiro", 300, 1_100),
        ("Estante Modular", 450, 1_700),
    ],
    "Casa": [
        ("Cafeteira", 220, 1_400),
        ("Aspirador Robo", 980, 3_200),
        ("Purificador de Ar", 600, 2_100),
        ("Luminaria Smart", 90, 420),
    ],
    "Esporte": [
        ("Bicicleta Urbana", 1_300, 4_800),
        ("Esteira Compacta", 2_200, 7_500),
        ("Halteres Ajustaveis", 350, 1_500),
        ("Tenis Running", 220, 850),
    ],
    "Moda": [
        ("Mochila Executiva", 160, 680),
        ("Jaqueta Corta Vento", 180, 700),
        ("Relogio Casual", 120, 1_100),
        ("Oculos de Sol", 90, 650),
    ],
}


def weighted_choice(options: list[tuple[str, float]]) -> str:
    marker = random.random()
    total = 0.0
    for value, weight in options:
        total += weight
        if marker <= total:
            return value
    return options[-1][0]


def money(value: float) -> str:
    return f"{value:.2f}"


def write_csv(path: Path, fieldnames: list[str], rows: list[dict[str, object]]) -> None:
    with path.open("w", newline="", encoding="utf-8") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def generate_customers() -> list[dict[str, object]]:
    customers = []
    start = date(2023, 1, 1)
    end = date(2025, 12, 31)
    days = (end - start).days

    for customer_id in range(1, CUSTOMER_COUNT + 1):
        first_name = random.choice(FIRST_NAMES)
        last_name = random.choice(LAST_NAMES)
        signup_date = start + timedelta(days=random.randint(0, days))
        email = f"{first_name}.{last_name}.{customer_id}@example.com".lower()

        customers.append(
            {
                "customer_id": customer_id,
                "first_name": first_name,
                "last_name": last_name,
                "email": email,
                "signup_date": signup_date.isoformat(),
                "country": random.choice(COUNTRIES),
            }
        )

    return customers


def generate_products() -> list[dict[str, object]]:
    products = []
    product_id = 101

    while len(products) < PRODUCT_COUNT:
        category = random.choice(list(CATEGORY_CATALOG))
        base_name, low_price, high_price = random.choice(CATEGORY_CATALOG[category])
        variant = random.choice(["Basic", "Plus", "Pro", "Max", "Studio", "Compact"])
        unit_price = round(random.uniform(low_price, high_price) / 10) * 10 - 0.1

        products.append(
            {
                "product_id": product_id,
                "product_name": f"{base_name} {variant} {product_id}",
                "category": category,
                "unit_price": money(unit_price),
                "is_active": "true" if random.random() > 0.08 else "false",
            }
        )
        product_id += 1

    return products


def generate_orders(customers: list[dict[str, object]]) -> list[dict[str, object]]:
    orders = []
    start = date(2024, 1, 1)
    end = date(2025, 12, 31)
    days = (end - start).days

    for offset in range(ORDER_COUNT):
        order_date = start + timedelta(days=random.randint(0, days))
        status = weighted_choice(STATUS_WEIGHTS)

        orders.append(
            {
                "order_id": 1001 + offset,
                "customer_id": random.choice(customers)["customer_id"],
                "order_date": order_date.isoformat(),
                "status": status,
                "payment_method": random.choice(PAYMENT_METHODS),
            }
        )

    orders.sort(key=lambda row: (row["order_date"], row["order_id"]))
    return orders


def generate_order_items(
    orders: list[dict[str, object]], products: list[dict[str, object]]
) -> list[dict[str, object]]:
    items = []
    item_id = 1

    category_multiplier = {
        "Eletronicos": 1,
        "Moveis": 1,
        "Casa": 2,
        "Esporte": 1,
        "Moda": 3,
    }

    for order in orders:
        line_count = random.choices([1, 2, 3, 4, 5], weights=[45, 30, 15, 7, 3])[0]
        chosen_products = random.sample(products, k=line_count)

        for product in chosen_products:
            max_qty = category_multiplier[product["category"]]
            quantity = random.choices(
                range(1, max_qty + 2),
                weights=list(reversed(range(1, max_qty + 2))),
            )[0]
            catalog_price = float(product["unit_price"])
            discount = random.choices([0, 0.05, 0.10, 0.15], weights=[65, 20, 10, 5])[0]
            unit_price = round(catalog_price * (1 - discount), 2)

            items.append(
                {
                    "order_item_id": item_id,
                    "order_id": order["order_id"],
                    "product_id": product["product_id"],
                    "quantity": quantity,
                    "unit_price": money(unit_price),
                }
            )
            item_id += 1

    return items


def main() -> None:
    random.seed(RANDOM_SEED)
    SEEDS_DIR.mkdir(parents=True, exist_ok=True)

    customers = generate_customers()
    products = generate_products()
    orders = generate_orders(customers)
    order_items = generate_order_items(orders, products)

    write_csv(
        SEEDS_DIR / "raw_customers.csv",
        ["customer_id", "first_name", "last_name", "email", "signup_date", "country"],
        customers,
    )
    write_csv(
        SEEDS_DIR / "raw_products.csv",
        ["product_id", "product_name", "category", "unit_price", "is_active"],
        products,
    )
    write_csv(
        SEEDS_DIR / "raw_orders.csv",
        ["order_id", "customer_id", "order_date", "status", "payment_method"],
        orders,
    )
    write_csv(
        SEEDS_DIR / "raw_order_items.csv",
        ["order_item_id", "order_id", "product_id", "quantity", "unit_price"],
        order_items,
    )

    print(f"Clientes: {len(customers):,}".replace(",", "."))
    print(f"Produtos: {len(products):,}".replace(",", "."))
    print(f"Pedidos: {len(orders):,}".replace(",", "."))
    print(f"Itens de pedido: {len(order_items):,}".replace(",", "."))


if __name__ == "__main__":
    main()
