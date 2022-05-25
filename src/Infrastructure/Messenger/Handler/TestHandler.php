<?php

declare(strict_types=1);

namespace App\Infrastructure\Messenger\Handler;

use App\Infrastructure\Messenger\Message\Test;
use Psr\Log\LoggerInterface;
use Symfony\Component\Messenger\Handler\MessageHandlerInterface;

class TestHandler implements MessageHandlerInterface
{
    public function __construct(private LoggerInterface $logger)
    {
    }

    public function __invoke(Test $testMessage)
    {
        $this->logger->info(
            sprintf(
                'message uuid - %s, message content - %s',
                $testMessage->getUuid(),
                $testMessage->getCreatedAt()
            )
        );
    }
}
