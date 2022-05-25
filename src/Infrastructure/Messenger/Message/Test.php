<?php

declare(strict_types=1);

namespace App\Infrastructure\Messenger\Message;

use Ramsey\Uuid\Uuid;

class Test
{
    public function __construct(private string $createdAt, private string $uuid)
    {
    }

    public function getCreatedAt(): string
    {
        return $this->createdAt;
    }

    public function getUuid(): string
    {
        return $this->uuid;
    }

    public static function create(): static
    {
        return new self(date(DATE_RFC3339_EXTENDED), Uuid::uuid4()->toString());
    }
}
