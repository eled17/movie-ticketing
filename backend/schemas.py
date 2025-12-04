from pydantic import BaseModel

class MovieBase(BaseModel):
    title: str
    description: str


class MovieCreate(MovieBase):
    pass


class Movie(MovieBase):
    id: int

    class Config:
        orm_mode = True


class ShowtimeBase(BaseModel):
    movie_id: int
    time: str


class ShowtimeCreate(ShowtimeBase):
    pass


class Showtime(ShowtimeBase):
    id: int

    class Config:
        orm_mode = True


class TicketBase(BaseModel):
    showtime_id: int
    seat_number: str


class TicketCreate(TicketBase):
    pass


class Ticket(TicketBase):
    id: int

    class Config:
        orm_mode = True
